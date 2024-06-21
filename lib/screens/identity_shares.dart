import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jamiipass_mobile/model/user_model.dart';
import 'package:provider/provider.dart';

import '../api/api.dart';
import '../constants/app_constants.dart';
import '../constants/custom_colors.dart';
import '../helper/id_history_helper.dart';
import '../providers/user_management_provider.dart';
import '../widgets/app_large_text.dart';
import '../widgets/app_small_text.dart';
import 'id_history_dsc.dart';

class IdentitySharesScreen extends StatefulWidget {
  const IdentitySharesScreen({Key? key}) : super(key: key);

  @override
  State<IdentitySharesScreen> createState() => _IdentitySharesScreenState();
}

class _IdentitySharesScreenState extends State<IdentitySharesScreen> {
  List<dynamic> identityShareHistories = [];
  bool isLoading = false;

  _userLoadIdentities() async {
    final userAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);
    dynamic token = userAuthProvider.authState.user.apiToken;

    setState(() {
      isLoading = true;
    });
    try {
      var res = await CallApi().authenticatedRequest({},
          AppConstants.apiBaseUrl + AppConstants.userShareHistory,
          'get',
          token);

      var body = json.decode(res);
      setState(() {
        identityShareHistories = body['data'];
      });
      print(identityShareHistories);
    } catch (error) {
      Fluttertoast.showToast(
          msg: "Error: Failing to get histories, check network and try again",
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
    _userLoadIdentities();
  }

  void _deleteIdentityShare(dynamic id) async {
    final userAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);
    User token = userAuthProvider.authState.user;

    try {
        print("------------------------------");
      final id_to_delete = id['corp_id'] ?? id['user_share'];
      print("------------------------------");
      var URL =
          "${AppConstants.apiBaseUrl}${AppConstants.userDeleteShareHistory}?user_id=${token.id}&&delete_id=$id_to_delete";
          print(URL);
      var res = await CallApi().authenticatedRequest({},
          URL,
          'get',
          "token");
          print(res);

      var body = json.decode(res);
      if (body['success']) {
         Fluttertoast.showToast(
          msg: "Identity share deleted successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 13.0);
          _userLoadIdentities();
          Navigator.of(context).pop();
      }
      print(identityShareHistories);
    } catch (error) {
      Fluttertoast.showToast(
          msg: "Error: Failing to delete, check network and try again",
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.buttonBackground,
      appBar: AppBar(
        backgroundColor: AppColors.buttonBackground,
        title: AppLargeText(
          text: "All Identity Shares",
          size: 18,
        ),
      ),
      body: isLoading
          ? Center(
              child: AppSmallText(
                text: "Loading....",
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildIdHistory(identityShareHistories),
            ),
    );
  }

  Widget _buildIdHistory(List<dynamic> ids) {
    return ListView.builder(
      itemCount: ids.length,
      itemBuilder: (context, index) {
        final id = ids[index];
        return InkWell(
          onTap: () => {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                 return AlertDialog(
                    backgroundColor: AppColors.buttonBackground,
                    title: const Text('Delete Identity share'),
                    content: const Text(
                        'Are you sure you want delete this share the other party wont be able to see it anymore?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                         _deleteIdentityShare(id);
                        },
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                })
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppLargeText(
                      text: id['corp_name'],
                      size: 14,
                      color: AppColors.bigTextColor,
                    ),
                    AppSmallText(
                      text: id['cards'],
                      size: 10,
                      color: AppColors.mainTextColor,
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
                    Icons.delete_outline,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
