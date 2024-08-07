import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jamiipass_mobile/constants/app_constants.dart';
import 'package:jamiipass_mobile/constants/custom_colors.dart';
import 'package:jamiipass_mobile/widgets/app_large_text.dart';
import 'package:jamiipass_mobile/widgets/app_small_text.dart';
import 'package:provider/provider.dart';

import '../api/api.dart';
import '../api/identity_cache.dart';
import '../configs/langConfg/localization/localization_constants.dart';
import '../providers/user_management_provider.dart';
import '../screens/Identity_view.dart';
import '../screens/all_id_requests.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> identityData = [];
    List<dynamic> identityRequests = [];
  bool isLoading = true;
  dynamic stats;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final userAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);
    dynamic user = userAuthProvider.authState.user.id;
    try {
      final data = await fetchIdentityData(
          "${AppConstants.apiBaseUrl}${AppConstants.getIdentitiesFromNtwork}?fcn=GetIdentitiesByUserID&&args=$user");
       var res = await CallApi().authenticatedRequest({},
          '${AppConstants.apiBaseUrl}${AppConstants.homeStats}/$user',
          'get',
          "hdhjd"
          );

             var ress = await CallApi().authenticatedRequest({},
          '${AppConstants.apiBaseUrl}${AppConstants.allIdentificationRequest}/$user',
          'get',
          "token");

          print(res);
       var body = json.decode(ress);
    
      setState(() {
        identityData = data;
          identityRequests = body['data'];
        isLoading = false;
        stats = json.decode(res);
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
      final userAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);
    final user = userAuthProvider.authState.user;
    return Center(
        child: Scaffold(
      // appBar: AppBar(),
      backgroundColor: AppColors.buttonBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 60, left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppLargeText(
                          text:
                              "${getTranslated(context, "home_welcm").toString()}, ${user.lastName}",
                          size: 20,
                        ),
                        AppSmallText(
                          text:
                              getTranslated(context, "home_welcm_txt").toString(),
                          size: 14,
                        )
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          // color: Colors.grey.withOpacity(0.5),
                               image: DecorationImage(image: 
                                user.profile == null ? const NetworkImage("https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?t=st=1719906880~exp=1719910480~hmac=99c3f74ad8d7efd05f67d32f288897ebe28a16b877c7d1dd3159fecc2659c173&w=900") :NetworkImage("${AppConstants.mediaBaseUrl}/${user.profile}") ,
                             fit: BoxFit.cover
                          ),
                    
                          ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                // height: 200,
                margin: EdgeInsets.only(left: 20, right: 20),
                width: double.maxFinite,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 20),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.grey.withOpacity(0.3)),
                      child: const Icon(
                        Icons.add_circle_outline,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppLargeText(
                      text: getTranslated(context, "home_hero_title").toString(),
                      size: 13,
                      color: Colors.white,
                    ),
                    AppSmallText(
                      text: getTranslated(context, "home_hero_dsc").toString(),
                      color: Colors.white,
                      size: 11,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Set border radius here
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, '/request_identity_select_org');
                        },
                        child: Text(
                          getTranslated(context, "home_hero_btn").toString(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 150,
                    // Adjusted margin
                    width: MediaQuery.of(context).size.width *
                        0.45, // Used MediaQuery for device width
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 20),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.black,
                          ),
                          child: const Icon(
                            Icons.account_box_outlined,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppSmallText(
                                  text: getTranslated(
                                          context, "home_total_identities")
                                      .toString(),
                                  size: 10,
                                  color: AppColors.mainTextColor,
                                ),
                                AppLargeText(
                                  text:
                                      "${identityData.length} ${getTranslated(context, "identity").toString()}",
                                  size: 12,
                                  color: AppColors.bigTextColor,
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/identities');
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 5),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 1,
                                        color: AppColors.buttonBackground)),
                                child: const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 150,
                    // Adjusted margin
                    width: MediaQuery.of(context).size.width *
                        0.45, // Used MediaQuery for device width
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 20),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: AppColors.accentColor,
                          ),
                          child: const Icon(
                            Icons.add_card_outlined,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppSmallText(
                                  text:
                                      getTranslated(context, "home_total_shared")
                                          .toString(),
                                  size: 12,
                                  color: AppColors.mainTextColor,
                                ),
                                AppLargeText(
                                  text:
                                      "${identityRequests.length} ${getTranslated(context, "identity").toString()}",
                                  size: 10,
                                  color: AppColors.bigTextColor,
                                ),
                              ],
                            ),
                            GestureDetector(
                                  onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const AllIdentityRequests(),
                                            ));
                                      },
                              child: Container(
                                margin: const EdgeInsets.only(right: 5),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 1,
                                        color: AppColors.buttonBackground)),
                                child: const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppLargeText(
                          text:
                              getTranslated(context, "home_your_ids").toString(),
                          size: 13,
                          color: AppColors.bigTextColor,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/identities');
                          },
                          child: AppSmallText(
                            text: getTranslated(context, "home_view_btn")
                                .toString(),
                            size: 13,
                            color: AppColors.bigTextColor,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 300,
                child:  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                  child: _buildTopThreeIdentities(identityData.reversed),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildTopThreeIdentities(dynamic ids) {
    final topThreeIds = ids.take(3).toList();

    return Column(
      children: topThreeIds.map<Widget>((id) {
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewIdentityFile(
                        transactionId: id['transactionId'],
                      )),
            );
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 20),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.buttonBackground,
                              image: DecorationImage(
                                  image: AssetImage(id['organization'] == "NIDA"
                                      ? "assets/nida.jpg"
                                      : id['organization'] == "NHIF"
                                          ? "assets/nhif.jpg"
                                          : id['organization'] == "DIT"
                                              ? "assets/dit.png"
                                              : id['organization'] == "RITA"
                                                  ? "assets/rita.jpeg"
                                                  : id['organization'] == "TRA"
                                                      ? "assets/tra.png"
                                                      : "assets/nida.jpg"),
                                  fit: BoxFit.cover)),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppLargeText(
                              text: "${id['documentNo']}",
                              size: 14,
                              color: AppColors.bigTextColor,
                            ),
                            AppSmallText(
                              text: "${id['organization']}",
                              size: 10,
                              color: AppColors.mainTextColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                          border: Border.all(
                              width: 1, color: AppColors.buttonBackground)),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.black,
                      ),
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
      }).toList(),
    );
  }
}
