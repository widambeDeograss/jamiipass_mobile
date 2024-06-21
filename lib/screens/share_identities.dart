import 'dart:convert';

import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jamiipass_mobile/widgets/app_small_text.dart';
import 'package:provider/provider.dart';

import '../api/api.dart';
import '../api/identity_cache.dart';
import '../configs/langConfg/localization/localization_constants.dart';
import '../constants/app_constants.dart';
import '../constants/custom_colors.dart';
import '../providers/user_management_provider.dart';
import '../widgets/app_large_text.dart';
import 'share_id_result.dart';

class ShareIdentities extends StatefulWidget {
  final id;
  final typeShare;
  const ShareIdentities({super.key, this.id, this.typeShare});
  @override
  State<ShareIdentities> createState() => _ShareIdentitiesState();
}

class _ShareIdentitiesState extends State<ShareIdentities> {
  List<Map<String, dynamic>> identityData = [];
  List<Map<String, dynamic>> identitiesToShare = [];
  DateTime? corruptDate;
  bool isLoading = false;
  bool isPostingShare = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _addIdToShares(Map<String, dynamic> id) {
    var data = {
      'card': id['documentNo'],
      'trsId': id['transactionId'],
      'org': id['organization']
    };

    identitiesToShare.removeWhere((element) =>
        element['card'] == data['card'] && element['trsId'] == data['trsId']);

    identitiesToShare.insert(0, data);

    if (identitiesToShare.length > 3) {
      identitiesToShare.removeLast();
    }

    setState(() {});
  }

  Future<void> _sendDataToServer() async {
    final userAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);
    dynamic user = userAuthProvider.authState.user.id;
    // Ensure there are exactly three elements
    if (identitiesToShare.length == 0) {
      print('Exactly three identities must be selected.');
      return;
    }

    // Concatenate transaction IDs and card numbers
    String sharedHash = identitiesToShare.map((e) => e['trsId']).join('_');
    String cards = identitiesToShare.map((e) => e['card']).join('_');

    var shareData = {
      'user_id': user,
      'corp_id': widget.typeShare == "corp" ? widget.id : null,
      'user_share': widget.typeShare == "corp" ? null : widget.id,
      'shared_hash': sharedHash,
      'cards': cards,
      'time_before_corrupt':
          "${corruptDate?.year}-${corruptDate?.month}-${corruptDate?.day}",
    };
    print('Share data: $shareData');

    // Send the data to the server
    try {
      setState(() {
        isPostingShare = true;
      });
    //    final response = await http.put(
    //   Uri.parse(AppConstants.apiBaseUrl + AppConstants.userUpdateProfilePic),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: jsonEncode(<String, String>{
    //     'email': userEmailController.text,
    //     'phone': userPhoneController.text,
    //   }),
    // );

      String apiUrl = "${AppConstants.apiBaseUrl}${AppConstants.corpShareId}";
      // String token = userAuthProvider.authState.user.apiToken;

      var res = await CallApi()
          .authenticatedRequest(shareData, apiUrl, 'post', "token");

      var body = json.decode(res);
      print('Response body: $body');

      if (body['success']) {
        print('Data sent successfully');

        Fluttertoast.showToast(
          msg: "Success:Identity shared successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => IdShareResults(
                    identities: identitiesToShare,
                  )),
        );
      } else {
        print('Failed to send data');
        Fluttertoast.showToast(
          msg: "Error: Failed to share try again later",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print('Error sending data: $e');
      Fluttertoast.showToast(
        msg: "Error: Failed to share try again later",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        isPostingShare = false;
      });
    }
  }

  Future<void> _fetchData() async {
    final userAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);
    dynamic user = userAuthProvider.authState.user.id;
    try {
      final data = await fetchIdentityData(
          "${AppConstants.apiBaseUrl}${AppConstants.getIdentitiesFromNtwork}?fcn=GetIdentitiesByUserID&&args=$user");
      setState(() {
        identityData = data;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: "Error: Failed to fetch data",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.buttonBackground,
      appBar: AppBar(
        backgroundColor: AppColors.buttonBackground,
        title: AppLargeText(
          text: getTranslated(context, "share_id_title").toString(),
          size: 16,
        ),
      ),
      body: Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Row(
                children: [
                  AppSmallText(
                      text: widget.typeShare == "user"
                          ? getTranslated(context, "share_id_send_user")
                              .toString()
                          : getTranslated(context, "share_id_send_corp")
                              .toString()),
                  IconButton(
                    onPressed: () => {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: SizedBox(
                              width: 300,
                              height: 400,
                              child: DatePicker(
                                minDate: DateTime(2024, 1, 1),
                                maxDate: DateTime(2024, 12, 31),
                                onDateSelected: (value) {
                                  setState(() {
                                    corruptDate = value;
                                  });
                                  // Handle selected date
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                              ),
                            ),
                          );
                        },
                      )
                    },
                    icon: const Icon(Icons.calendar_month_sharp),
                  )
                ],
              ),
              const Divider(
                height: 1,
              ),
              Container(
                child: Expanded(child: _buildIdenityShares(identityData)),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    backgroundColor: AppColors.mainColor,
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(
                    //       10), // Set border radius here
                    // ),
                  ),
                  onPressed: () {
                    _sendDataToServer();
                  },
                  child: Text(
                    getTranslated(context, 'share_id_btn').toString(),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          )),
    );
  }

  Widget _buildIdenityShares(dynamic ids) {
    return ListView.builder(
      itemCount: ids.length,
      itemBuilder: (context, index) {
        final id = ids[index];
        bool isSelected = identitiesToShare.any((element) =>
            element['card'] == id['documentNo'] &&
            element['trsId'] == id['transactionId']);
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                _addIdToShares(id);
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        width: isSelected ? 2 : 1,
                        color: isSelected ? Colors.blue : Colors.black54),
                    color: Colors.white),
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: 60,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColors.buttonBackground,
                              image: const DecorationImage(
                                  image: AssetImage("assets/jamii_logo.jpg"),
                                  fit: BoxFit.cover)),
                        ),
                        Container(
                          width: 1,
                          height: 25,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 1, color: AppColors.bigTextColor)),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppLargeText(
                              text: "${id['documentNo']}",
                              size: 12,
                              color: AppColors.bigTextColor,
                            ),
                            AppLargeText(
                              text: "${id['organization']}",
                              size: 10,
                              color: AppColors.bigTextColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: isSelected ? Colors.blue : Colors.white,
                          border: Border.all(
                              width: 1, color: AppColors.bigTextColor)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        );
      },
    );
  }
}
