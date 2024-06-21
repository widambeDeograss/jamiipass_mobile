import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:slide_switcher/slide_switcher.dart';

import '../api/api.dart';
import '../configs/langConfg/localization/localization_constants.dart';
import '../constants/app_constants.dart';
import '../constants/custom_colors.dart';
import '../widgets/app_large_text.dart';
import '../widgets/app_small_text.dart';
import 'share_identities.dart';

class ShareIdFirstScreen extends StatefulWidget {
  const ShareIdFirstScreen({super.key});

  @override
  State<ShareIdFirstScreen> createState() => _ShareIdFirstScreenState();
}

class _ShareIdFirstScreenState extends State<ShareIdFirstScreen> {
  TextEditingController queryController = TextEditingController();
  int switcherIndex1 = 0;
  dynamic allOrganizations = [];
  dynamic allUsers = [];
  String selectedOrg = "";
  dynamic selectedOrgId;
  bool isLoading = false;

  _loadAllOrganizations() async {
    setState(() {
      isLoading = true;
    });
    try {
      var res = await CallApi().authenticatedRequest(
          {}, AppConstants.apiBaseUrl + AppConstants.allCorps, 'get', "");
      var resUsers = await CallApi().authenticatedRequest(
          {}, AppConstants.apiBaseUrl + AppConstants.allUsers, 'get', "");
      print(resUsers);
      var body = json.decode(res);
      var userBody = json.decode(resUsers);
      allOrganizations = body['data'];
      allUsers = userBody['data'];

    } catch (error) {
      Fluttertoast.showToast(
          msg: "Error:Failing to get Organizations check network and try again",
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
    _loadAllOrganizations();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.buttonBackground,
      appBar: AppBar(
        backgroundColor: AppColors.buttonBackground,
        title: AppLargeText(
          text: getTranslated(context, "share_screen_top").toString(),
          size: 16,
        ),
      ),
      body: Container(
        margin:const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            SizedBox(
              // width: MediaQuery.of(context).size.height * 0.36,
              child: SearchBar(
                controller: queryController,
                
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0)),
                onTap: () {},
                onChanged: (_) {},
                leading: const Icon(Icons.search),
              ),
            ),
           const SizedBox(height:10),
             Divider(),
            const SizedBox(height: 20),
            SlideSwitcher(
              onSelect: (index) => setState(() => switcherIndex1 = index),
              containerHeight: 40,
              containerWight: 350,
              children: [
                Text(getTranslated(context, "share_screen_user_tab").toString()),
                Text(getTranslated(context, "share_screen_corp_tab").toString()),
              ],
            ),
            const SizedBox(height: 20),
            if (switcherIndex1 == 0) ...[
              Container(
                child: Expanded(
                child: _buildUsers(allUsers),
                )
              )
            ] else ...[
              Container(
                child: Expanded(
                  child: _buildCorporates(allOrganizations)
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
  
   Widget _buildCorporates(List<dynamic> corps) {
    return ListView.builder(
      itemCount: corps.length,
      itemBuilder: (context, index) {
        final corp = corps[index];
        return InkWell(
          onTap: () => {

            Navigator.push(
              context,
              MaterialPageRoute(
                    builder: (context) => ShareIdentities(
                        id:corp['corp_id'],
                        typeShare:"corp"
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                           Container(
                      width: 55,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(
                              width: 1, color: AppColors.buttonBackground),
                              image: DecorationImage(image: NetworkImage("${AppConstants.mediaBaseUrl}/${corp['pic']}"))      
                              ),                  
                       ),
                         const SizedBox(
                width: 10,
              ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppLargeText(
                              text: "${corp['corp_name']}",
                              size: 14,
                              color: AppColors.bigTextColor,
                            ),
                            AppSmallText(
                              text: "${corp['phone']}",
                              size: 10,
                              color: AppColors.mainTextColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                 
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        );
      },
    );
  }

Widget _buildUsers(List<dynamic> users) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return InkWell(
          onTap: () => {

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ShareIdentities(
                        id:user['user_id'],
                        typeShare:"user"
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                           Container(
                      width: 55,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(
                              width: 1, color: AppColors.buttonBackground),
                              image: DecorationImage(image: NetworkImage("${AppConstants.mediaBaseUrl}/${user['profile']}"))      
                              ),
                     
                       ),
                           const SizedBox(
                width: 10,
              ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppLargeText(
                              text: "${user['first_name']} ${user['last_name']}",
                              size: 14,
                              color: AppColors.bigTextColor,
                            ),
                            AppSmallText(
                              text: "${user['email']}",
                              size: 10,
                              color: AppColors.mainTextColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                 
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        );
      },
    );
  }



  
}
