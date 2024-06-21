import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jamiipass_mobile/constants/app_constants.dart';
import 'package:provider/provider.dart';

import '../api/api.dart';
import '../configs/langConfg/localization/localization_constants.dart';
import '../constants/custom_colors.dart';
import '../providers/user_management_provider.dart';
import '../widgets/app_large_text.dart';
import '../widgets/app_small_text.dart';

class AllIdentityRequests extends StatefulWidget {
  const AllIdentityRequests({super.key});

  @override
  State<AllIdentityRequests> createState() => _AllIdentityRequestsState();
}

class _AllIdentityRequestsState extends State<AllIdentityRequests> {
  List<dynamic> identityRequests = [];

  bool isLoading = false;

  _userLoadRequestedIdentities() async {
    final userAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);
    // String? token = userAuthProvider.authState.corporate.apiToken;
    dynamic userId = userAuthProvider.authState.user.id;

    setState(() {
      isLoading = true;
    });
    try {
      var res = await CallApi().authenticatedRequest({},
          '${AppConstants.apiBaseUrl}${AppConstants.allIdentificationRequest}/$userId',
          'get',
          "token");
      print(res);
      var body = json.decode(res);
      identityRequests = body['data'];
    } catch (error) {
      Fluttertoast.showToast(
          msg: "Error:Failing to get Id requests check network and try again",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 13.0);
      print(error);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _userLoadRequestedIdentities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.buttonBackground,
      appBar: AppBar(
        backgroundColor: AppColors.buttonBackground,
        title: AppLargeText(
          text: getTranslated(context, "all_requests_title").toString(),
          size: 16,
        ),
      ),
      body: SafeArea(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              margin: const EdgeInsets.only(left: 20, right: 20),
              decoration:
                  const BoxDecoration(color: AppColors.buttonBackground),
              child: _buildIdRequests(identityRequests))),
    );
  }

  Widget _buildIdRequests(List<dynamic> ids) {
    return ListView.builder(
      itemCount: ids.length,
      itemBuilder: (context, index) {
        final id = ids[index];
        return InkWell(
          onTap: () => {
            //TODO: Implement identity request descriprion screen

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => IdentityHistoryScreen(
            //             identityHis: id,
            //           )),
            // ),
          },
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    // border: Border.all(width: 1, color: Colors.black54),
                    color: Colors.white),
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppLargeText(
                              text: "${id['org_name']}",
                              size: 14,
                              color: AppColors.bigTextColor,
                            ),
                            AppSmallText(
                              text: "${id['cert_name']}",
                              size: 10,
                              color: AppColors.mainTextColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 65,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(
                              width: 1, color: AppColors.buttonBackground)),
                      child: Center(
                        child: AppSmallText(
                          text: "${id['request_state']}",
                          size: 10,
                          color: AppColors.mainTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
         
              
            ],
          ),
        );
      },
    );
  }
}
