import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../api/api.dart';
import '../configs/langConfg/localization/localization_constants.dart';
import '../constants/app_constants.dart';
import '../constants/custom_colors.dart';
import '../helper/id_history_helper.dart';
import '../providers/user_management_provider.dart';
import '../widgets/app_large_text.dart';
import '../widgets/app_small_text.dart';
import 'id_history_dsc.dart';

class ActiveIdentityShareScreen extends StatefulWidget {
  const ActiveIdentityShareScreen({Key? key}) : super(key: key);

  @override
  State<ActiveIdentityShareScreen> createState() =>
      _ActiveIdentityShareScreenState();
}

class _ActiveIdentityShareScreenState extends State<ActiveIdentityShareScreen> {
  List<IdHistory> identityShareHistories = [];
  bool isLoading = false;

  _corporateLoadIdentities() async {
    final userAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);
    dynamic token = userAuthProvider.authState.corporate.apiToken;

    setState(() {
      isLoading = true;
    });
    try {
      var res = await CallApi().authenticatedRequest({},
          AppConstants.apiBaseUrl + AppConstants.corpShareHistory,
          'get',
          token);
      print(res);
      var body = json.decode(res);
      IdHistoryList idList = IdHistoryHelper.filterIdHistory(body['data']);
      identityShareHistories = idList.activeIdHistory;
    } catch (error) {
      Fluttertoast.showToast(
          msg: "Error:Failing to get histories check network and try again",
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
    // TODO: implement initState
    super.initState();
    _corporateLoadIdentities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.buttonBackground,
        appBar: AppBar(
          backgroundColor: AppColors.buttonBackground,
          title: AppLargeText(
            text: getTranslated(context, "corp_all_active_idshares").toString(),
            size: 16,
          ),
        ),
        body: SafeArea(
          child: isLoading
              ? Center(
                  child: AppSmallText(
                    text: "Loading....",
                  ),
                )
              : Expanded(
                  child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: _buildIdHistory(identityShareHistories),
                )),
        ));
  }

  Widget _buildIdHistory(List<IdHistory> ids) {
    return ListView.builder(
      itemCount: ids.length,
      itemBuilder: (context, index) {
        final id = ids[index];
        return InkWell(
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => IdentityHistoryScreen(
                        identityHis: id,
                      )),
            ),
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
                              text:
                                  "${id.firstName}  ${id.middleName} ${id.lastName}",
                              size: 14,
                              color: AppColors.bigTextColor,
                            ),
                            AppSmallText(
                              text: id.cards,
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
              SizedBox(
                height: 10,
              )
            ],
          ),
        );
      },
    );
  }
}
