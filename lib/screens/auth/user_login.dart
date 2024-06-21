import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jamiipass_mobile/screens/auth/user_registration.dart';

import '../../api/api.dart';
import '../../configs/langConfg/localization/localization_constants.dart';
import '../../constants/app_constants.dart';
import '../../constants/custom_colors.dart';
import 'corp_login.dart';
import 'otp_verification.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isUserLogin = true;
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController userPhoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  bool validateEmail(String email) {
    String pattern =
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  void changeLoginType() {
    setState(() {
      isUserLogin = !isUserLogin;
    });
  }

  _userLoginFnc() async {
    if (userPhoneController.text.isEmpty &&
        userPasswordController.text.isEmpty) {
      return;
    }
    var data = {
      "user_phone": userPhoneController.text,
      "user_password": userPasswordController.text
    };

    print(data);
    setState(() {
      isLoading = true;
    });
    try {
      var res = await CallApi()
          .authenticatedRequest(data, AppConstants.apiUserLogin, 'post', "");
      print(res);
      var body = json.decode(res);

      if (body['save']) {
        print("object=========================");
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
              isCorp: "citizen",
              userId: body["user"]["user_id"],
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.buttonBackground,
      body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
                  child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          // height: MediaQuery.of(context).size.height * 0.1,
                          ),
                      Center(
                        child: Image.asset(
                          'assets/logo.png',
                          height: 100,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          getTranslated(context, "login_title").toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          changeLoginType();
                        },
                        child: Container(
                          width: 100.0,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              border: Border.all(
                                  width: 1,
                                  color: isUserLogin
                                      ? AppColors.bigTextColor
                                      : Colors.blue)),
                          child: Center(
                            child: Text(
                              getTranslated(context, "login_corp").toString(),
                              style: TextStyle(
                                  color:
                                      isUserLogin ? Colors.black54 : Colors.blue),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          changeLoginType();
                        },
                        child: Container(
                          width: 100.0,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              border: Border.all(
                                  width: 1,
                                  color: isUserLogin
                                      ? Colors.blue
                                      : AppColors.bigTextColor)),
                          child: Center(
                            child: Text(
                              getTranslated(context, "login_user").toString(),
                              style: TextStyle(
                                  color:
                                      isUserLogin ? Colors.blue : Colors.black54),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      child: isUserLogin
                          ? Center(
                              child: Column(
                                children: [
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        TextFormField(
                                          controller: userPhoneController,
                                          // validator: validateUsername,
                                          keyboardType: TextInputType.phone,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
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
                                                    context, "register_phone")
                                                .toString(),
                                            hintStyle: const TextStyle(
                                              color: Colors.black12,
                                              fontSize: 14,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        TextFormField(
                                          controller: userPasswordController,
                                          obscureText: true,
                                          // validator: validatePassword,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
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
                                                    context, "register_password")
                                                .toString(),
                                            hintStyle: const TextStyle(
                                              color: Colors.black12,
                                              fontSize: 14,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
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
                                          onTap: () {
                                            _userLoginFnc();
                                            // OtpScreen(
                                            //   isCorp: "citizen",
                                            //   userId: "",
                                            // ),
                                          },
                                          borderRadius:
                                              BorderRadius.circular(14.0),
                                          child: Center(
                                            child: isLoading
                                                ? const CircularProgressIndicator(
                                                    color: Colors.white,
                                                  )
                                                : Text(
                                                    getTranslated(
                                                            context, "login")
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        getTranslated(context, "register_already")
                                            .toString(),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const RegisterScreen()));
                                        },
                                        child: Text(
                                          getTranslated(context, "register_click")
                                              .toString(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : const CorporateLoginScreen())
                ],
              ),
            ),
                  ),
                ),
          )),
    );
  }
}
