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
  List<dynamic> displayedUsers = [];
  List<dynamic> displayedCorporates = [];

  _loadAllOrganizations() async {
    setState(() {
      isLoading = true;
    });
    try {
      var res = await CallApi().authenticatedRequest(
          {}, AppConstants.apiBaseUrl + AppConstants.allCorps, 'get', "");
      var resUsers = await CallApi().authenticatedRequest(
          {}, AppConstants.apiBaseUrl + AppConstants.allUsers, 'get', "");
      var body = json.decode(res);
      var userBody = json.decode(resUsers);
      allOrganizations = body['data'];
      allUsers = userBody['data'];

      // Initialize displayed lists with all data
      displayedUsers = List.from(allUsers);
      displayedCorporates = List.from(allOrganizations);
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error: Failing to get Organizations. Check network and try again",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 13.0,
      );
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

  void _performSearch(String query) {
    setState(() {
      if (switcherIndex1 == 0) {
        // Search in users
        displayedUsers = allUsers
            .where((user) =>
                user['first_name'].toLowerCase().contains(query.toLowerCase()) ||
                user['last_name'].toLowerCase().contains(query.toLowerCase()) ||
                user['email'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        // Search in organizations
        displayedCorporates = allOrganizations
            .where((corp) =>
                corp['corp_name']
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
      }
    });
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
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            SizedBox(
              child: SearchBar(
                controller: queryController,
                padding:
                    MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16.0)),
                onTap: () {},
                onChanged: _performSearch,
                leading: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 20),
            SlideSwitcher(
              onSelect: (index) => setState(() => switcherIndex1 = index),
              containerHeight: 40,
              containerWight: 350,
              children: [
                Text(getTranslated(context, "share_screen_user_tab").toString()),
                Text(getTranslated(context, "share_screen_corp_tab").toString()),
              ],
            ),
            SizedBox(height: 20),
            if (switcherIndex1 == 0)
              Expanded(
                child: _buildUsers(queryController.text.isEmpty? allUsers : displayedUsers),
              )
            else
              Expanded(
                child: _buildCorporates(queryController.text.isEmpty?allOrganizations : displayedCorporates),
              ),
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
                  id: corp['corp_id'],
                  typeShare: "corp",
                ),
              ),
            ),
          },
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 55,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(width: 1, color: AppColors.buttonBackground),
                        image: DecorationImage(
                          image: NetworkImage(
                            "${AppConstants.mediaBaseUrl}/${corp['pic']}",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
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
              ),
              SizedBox(height: 10),
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
                  id: user['user_id'],
                  typeShare: "user",
                ),
              ),
            ),
          },
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 55,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(width: 1, color: AppColors.buttonBackground),
                        image: DecorationImage(
                          image: NetworkImage(
                            "${AppConstants.mediaBaseUrl}/${user['profile']}",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
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
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
