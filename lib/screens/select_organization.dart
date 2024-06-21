import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jamiipass_mobile/widgets/app_large_text.dart';

import '../api/api.dart';
import '../configs/langConfg/localization/localization_constants.dart';
import '../constants/app_constants.dart';
import '../constants/custom_colors.dart';
import 'identity_request.dart';

class SelectOrganizationForIdRequest extends StatefulWidget {
  const SelectOrganizationForIdRequest({Key? key}) : super(key: key);

  @override
  State<SelectOrganizationForIdRequest> createState() =>
      _SelectOrganizationForIdRequestState();
}

class _SelectOrganizationForIdRequestState
    extends State<SelectOrganizationForIdRequest> {
  dynamic allOrganizations = [];
  String selectedOrg = "";
  dynamic selectedOrgId;
  bool isLoading = false;

  _loadAllOrganizations() async {
    setState(() {
      isLoading = true;
    });
    try {
      var res = await CallApi().authenticatedRequest(
          {}, AppConstants.apiBaseUrl + AppConstants.allOrgs, 'get', "");
      print(res);
      var body = json.decode(res);
      allOrganizations = body['data'];
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
    // TODO: implement initState
    super.initState();
    _loadAllOrganizations();
  }

  void selectOrg(String org) {
    setState(() {
      selectedOrg = org;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.buttonBackground,
      appBar: AppBar(
        backgroundColor: AppColors.buttonBackground,
        title: AppLargeText(
          text: getTranslated(context, "select_organization").toString(),
          size: 16,
        ),

        // backgroundColor: Colors.white,
      ),
      body: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Stack(
          children: [
            Positioned(
              top: 20,
              right: 0,
              left: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                margin: const EdgeInsets.only(left: 20, right: 20),
                decoration:
                    const BoxDecoration(color: AppColors.buttonBackground),
                child: Expanded(
                  child: _buildIdOrg(allOrganizations),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              top: MediaQuery.of(context).size.height * 0.73,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                decoration: const BoxDecoration(
                  color: AppColors.mainTextColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => IdentityRequestScr(
                                    organization: selectedOrgId,
                                  )),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.height * 0.64,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.blue,
                            border: Border.all(width: 1, color: Colors.blue)),
                        child: Center(
                          child: Text(
                            getTranslated(
                                    context, "select_organization_continue")
                                .toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        selectOrg("");
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.height * 0.64,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.black54,
                            border: Border.all(width: 1, color: Colors.blue)),
                        child: Center(
                          child: Text(
                            getTranslated(context, "select_organization_cancel")
                                .toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdOrg(dynamic orgs) {
    return ListView.builder(
      itemCount: orgs.length,
      itemBuilder: (context, index) {
        final org = orgs[index];
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                selectedOrgId = org;
                selectOrg("${org['org_id']}");
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        width: selectedOrg == "${org['org_id']}" ? 2 : 1,
                        color: selectedOrg == "${org['org_id']}"
                            ? Colors.blue
                            : Colors.black54),
                    color: Colors.white),
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: 40,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColors.buttonBackground,
                              image:  DecorationImage(
                                  image: AssetImage(
                                    org['org_name'] == "NIDA"
                                      ? "assets/nida.jpg"
                                      : org['org_name'] == "NHIF"
                                          ? "assets/nhif.jpg"
                                          : org['org_name'] == "DIT"
                                              ? "assets/dit.png"
                                              : org['org_name'] == "RITA"
                                                  ? "assets/rita.jpeg"
                                                  : org['org_name'] == "TRA"
                                                      ? "assets/tra.png"
                                                      : "assets/nida.jpg"
                                  ),
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
                              text: "${org['org_name']}",
                              size: 12,
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
                          color: selectedOrg == "${org['org_id']}"
                              ? Colors.blue
                              : Colors.white,
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
