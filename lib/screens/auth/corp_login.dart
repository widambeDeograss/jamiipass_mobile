import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jamiipass_mobile/constants/app_constants.dart';

import '../../api/api.dart';
import '../../configs/langConfg/localization/localization_constants.dart';
import '../../constants/custom_colors.dart';
import '../../widgets/app_small_text.dart';
import 'otp_verification.dart';

class CorporateLoginScreen extends StatefulWidget {
  const CorporateLoginScreen({Key? key}) : super(key: key);

  @override
  State<CorporateLoginScreen> createState() => _CorporateLoginScreenState();
}

class _CorporateLoginScreenState extends State<CorporateLoginScreen> {
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  late final String? corpIdResponse;

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  bool validateEmail(String email) {
    String pattern =
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  _corporateLoginFnc() async {
    if (userEmailController.text == "" && userPasswordController.text == "") {
      return;
    }
    var data = {
      "corp_email": userEmailController.text,
      "corp_password": userPasswordController.text
    };

    print(data);
    setState(() {
      isLoading = true;
    });
    try {
      var res = await CallApi().authenticatedRequest(
          data, AppConstants.apiCorpLogin, 'post', "gsgsgs");
      print(res);
      var body = json.decode(res);

      if (body['success']) {
        Fluttertoast.showToast(
            msg: "Login Successful!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(
              isCorp: "corp",
              corpId: body["corp"]["corp_id"],
            ),
          ),
        );
      } else {
        await Fluttertoast.showToast(
            msg: "Wrong credentials",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (error) {
      Fluttertoast.showToast(
          msg: "Error:Invalid login credentials",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print(error);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: userEmailController,
                    // validator: validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blueGrey.withOpacity(0.13),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          8,
                        ),
                        borderSide: BorderSide.none,
                      ),
                      hintText:
                          getTranslated(context, "login_email").toString(),
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
                  TextFormField(
                    controller: userPasswordController,
                    obscureText: true,
                    // validator: validatePassword,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blueGrey.withOpacity(0.13),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          8,
                        ),
                        borderSide: BorderSide.none,
                      ),
                      hintText:
                          getTranslated(context, "register_password")
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
                ],
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 12,
                ),
              ],
            ),
            Material(
              borderRadius: BorderRadius.circular(14.0),
              elevation: 0,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.circular(14.0),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      if (isLoading) {
                        return;
                      } else {
                        await _corporateLoginFnc();
                      }
                    },
                    borderRadius: BorderRadius.circular(14.0),
                    child: Center(
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                          : Text(
                              getTranslated(context, "login").toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ),
              ),
            ),
                const SizedBox(
                                  height: 30,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AppSmallText(text:getTranslated(context, "register_already_corp")
                                          .toString()),
                                    GestureDetector(
                                      onTap: () {
                                      
                                      },
                                      child: Text(
                                        getTranslated(context, "register_click_corp")
                                            .toString(),
                                      ),
                                    ),
                                  ],
                                ),
          ],
        ),
      ),
    );
  }
}
