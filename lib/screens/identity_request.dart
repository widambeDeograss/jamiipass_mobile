import 'dart:convert';

import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jamiipass_mobile/constants/custom_colors.dart';
import 'package:jamiipass_mobile/widgets/app_large_text.dart';
import 'package:provider/provider.dart';

import '../api/api.dart';
import '../configs/langConfg/localization/localization_constants.dart';
import '../constants/app_constants.dart';
import '../providers/user_management_provider.dart';
import '../widgets/app_small_text.dart';
import 'all_id_requests.dart';

class IdentityRequestScr extends StatefulWidget {
  final dynamic organization;
  const IdentityRequestScr({Key? key, this.organization}) : super(key: key);

  @override
  State<IdentityRequestScr> createState() => _IdentityRequestScrState();
}

class _IdentityRequestScrState extends State<IdentityRequestScr> {
  int activeStep = 0;
  dynamic orgIdentification = [];
  TextEditingController cardNumberController = TextEditingController();
  bool isLoading = false;
  bool isPosting = false;
  String selectedOrg = "";
  String selectedCertificate = "";

  _organizationLoadIdentifications() async {
    print("=======================");
    // final userAuthProvider =
    //     Provider.of<UserAuthProvider>(context, listen: false);
    // String? token = userAuthProvider.authState.corporate.apiToken;

    setState(() {
      isLoading = true;
    });
    try {
      var res = await CallApi().authenticatedRequest({},
          '${AppConstants.apiBaseUrl}${AppConstants.orgIdentification}/${widget.organization['org_id']}',
          'get',
          "token");
      print(res);
      var body = json.decode(res);
      orgIdentification = body['data'];
    } catch (error) {
      Fluttertoast.showToast(
          msg:
              "Error:Failing to get org identifications check network and try again",
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

  _postIdentityRequest() async {
    if (cardNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          getTranslated(context, "identity_request_err_fill_cardno").toString(),
        ),
      ));
      return;
    }

    final userAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);
    dynamic userId = userAuthProvider.authState.user.id;

    var data = {
      "card_no": cardNumberController.text,
      "cert_id": selectedOrg,
      "user_id": userId,
      "org_id": widget.organization['org_id']
    };

    print(data);
    setState(() {
      isPosting = true;
    });
    try {
      var res = await CallApi().authenticatedRequest(
          data,
          '${AppConstants.apiBaseUrl}${AppConstants.identificationRequest}',
          'post',
          "");
      print(res);
      var body = json.decode(res);

      if (body['success']) {
        Fluttertoast.showToast(
            msg:
                "Digital Identity for $selectedCertificate was posted successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          activeStep++;
        });
      } else {
        await Fluttertoast.showToast(
            msg: "Failing to post Digital Identity for $selectedCertificate",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (error) {
      Fluttertoast.showToast(
          msg:
              "Error:Failing to post Digital Identity for $selectedCertificate check your network",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print(error);
    } finally {
      setState(() {
        isPosting = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _organizationLoadIdentifications();
  }

  void selectOrg(String org) {
    setState(() {
      selectedOrg = org;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.buttonBackground,
      appBar: AppBar(
        backgroundColor: AppColors.buttonBackground,
        title: AppLargeText(
          text: getTranslated(context, "identity_request").toString(),
          size: 16,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            AppLargeText(
              text: getTranslated(context, "identity_request_title").toString(),
              size: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            EasyStepper(
              activeStep: activeStep,
              stepShape: StepShape.rRectangle,
              stepBorderRadius: 15,
              borderThickness: 2,
              enableStepTapping: false,
              // padding:EdgeInsetsGeometry.lerp(2, b, t),
              stepRadius: 23,
              finishedStepBorderColor: AppColors.mainColor,
              finishedStepTextColor: AppColors.mainColor,
              finishedStepBackgroundColor: AppColors.mainColor,
              activeStepIconColor: AppColors.mainColor,
              finishedStepIconColor: Colors.white,
              unreachedStepBorderColor: Colors.blue,
              lineStyle: const LineStyle(defaultLineColor: Colors.blue),
              showLoadingAnimation: true,
              
              steps: [
                EasyStep(
                  customStep: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Opacity(
                      opacity: activeStep >= 0 ? 1 : 0.3,
                      child: const Icon(Icons.add_card),
                    ),
                  ),
                  customTitle: Text(
                    getTranslated(context, "identity_request_step_one")
                        .toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
                EasyStep(
                  customStep: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Opacity(
                      opacity: activeStep >= 1 ? 1 : 0.3,
                      child: const Icon(Icons.add_card),
                    ),
                  ),
                  customTitle: Text(
                    getTranslated(context, "identity_request_step_two")
                        .toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
                EasyStep(
                  customStep: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Opacity(
                      opacity: activeStep >= 2 ? 1 : 0.3,
                      child: const Icon(Icons.access_time_filled_sharp),
                    ),
                  ),
                  customTitle: Text(
                    getTranslated(context, "identity_request_step_three")
                        .toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              onStepReached: (index) => setState(() => activeStep = index),
            ),
            Container(
                // width: double.maxFinite,
                // height: double.maxFinite,
                child: activeStep == 0
                    ? Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            AppLargeText(
                              text: '${widget.organization['org_name']}',
                              size: 16,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 450,
                              child: Expanded(
                                  child:
                                      _buildIdentifications(orgIdentification)),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      width: 100.0,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 1,
                                              color: AppColors.mainColor)),
                                      child: Center(
                                        child: Text(
                                          getTranslated(context,
                                                  "identity_request_Cancel")
                                              .toString(),
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (selectedCertificate.isNotEmpty) {
                                        setState(() {
                                          activeStep++;
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(getTranslated(context,
                                                  "identity_request_err_fill_id")
                                              .toString()),
                                        ));
                                      }
                                    },
                                    child: Container(
                                      width: 100.0,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.blue,
                                          border: Border.all(
                                              width: 1, color: Colors.blue)),
                                      child: Center(
                                        child: Text(
                                          getTranslated(context,
                                                  "identity_request_Continue")
                                              .toString(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : activeStep == 1
                        ? Container(
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                AppLargeText(
                                  text: selectedCertificate,
                                  size: 16,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  controller: cardNumberController,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor:
                                        Colors.blueGrey.withOpacity(0.13),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        8,
                                      ),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintText: getTranslated(
                                            context, "identity_request_card_no")
                                        .toString(),
                                    hintStyle: const TextStyle(
                                      color: Colors.black12,
                                      fontSize: 14,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: 100.0,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.white,
                                              border: Border.all(
                                                  width: 1,
                                                  color: AppColors.mainColor)),
                                          child: Center(
                                            child: Text(
                                              getTranslated(context,
                                                      "identity_request_Cancel")
                                                  .toString(),
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          if (cardNumberController
                                              .text.isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(getTranslated(
                                                      context,
                                                      "identity_request_err_fill_cardno")
                                                  .toString()),
                                            ));
                                          } else {
                                            // setState(() {
                                            //   activeStep++;
                                            // });
                                            _postIdentityRequest();
                                          }
                                        },
                                        child: Container(
                                          width: 100.0,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.blue,
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.blue)),
                                          child: Center(
                                            child: Text(
                                              getTranslated(context,
                                                      "identity_request_Continue")
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.only(left: 30, right: 30),
                            child: Center(
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  AppSmallText(
                                      text:
                                          "Digital Identity for $selectedCertificate with card number \n ${cardNumberController.text} was subbmitted successfully and \n requested to ${widget.organization['org_name']} waint for response"),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    getTranslated(context,
                                            "identity_request_view_all_requests")
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 6,
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
                                      // width: 100.0,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.blue,
                                          border: Border.all(
                                              width: 1, color: Colors.blue)),
                                      child: Center(
                                        child: Text(
                                          getTranslated(context,
                                                  "identity_request_all_requests_btn")
                                              .toString(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
          ],
        ),
      ),
    );
  }

  Widget _buildIdentifications(dynamic ids) {
    return ListView.builder(
      itemCount: ids.length,
      itemBuilder: (context, index) {
        final id = ids[index];
        return Column(
          children: [
            InkWell(
              onTap: () {
                selectOrg("${id['cert_id']}");
                selectedCertificate = "${id['cert_name']}";
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        width: selectedOrg == "${id['cert_id']}" ? 2 : 1,
                        color: selectedOrg == "${id['cert_id']}"
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
                              image: DecorationImage(
                                  image: AssetImage(widget
                                              .organization['org_name'] ==
                                          "NIDA"
                                      ? "assets/nida.jpg"
                                      : widget.organization['org_name'] ==
                                              "NHIF"
                                          ? "assets/nhif.jpg"
                                          : widget.organization['org_name'] ==
                                                  "DIT"
                                              ? "assets/dit.png"
                                              : widget.organization[
                                                          'org_name'] ==
                                                      "RITA"
                                                  ? "assets/rita.jpeg"
                                                  : widget.organization[
                                                              'org_name'] ==
                                                          "TRA"
                                                      ? "assets/tra.png"
                                                      : "assets/nida.jpg"),
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
                              text: "${id['cert_name']}",
                              size: 13,
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
                          color: selectedOrg == "${id['cert_id']}"
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
