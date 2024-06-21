import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jamiipass_mobile/api/api.dart';
import 'package:jamiipass_mobile/constants/custom_colors.dart';
import 'package:jamiipass_mobile/screens/auth/user_login.dart';

import '../../configs/langConfg/localization/localization_constants.dart';
import '../../constants/app_constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Map<String, Type> NidaResponse = {
    "DATEOFBIRTH": String,
    "DateofBirth": String,
    "FIRSTNAME": String,
    "FirstName": String,
    "LastName": String,
    "MIDDLENAME": String,
    "MiddleName": String,
    "NATIONALITY": String,
    "NIN": String,
    "NationalIDNumber": String,
    "Nationality": String,
    "SEX": String,
    "SURNAME": String,
    "Sex": String
  };

  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPhoneController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController sexController = TextEditingController();
  TextEditingController ninController = TextEditingController();
  TextEditingController profileController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool loadingNidaInfo = false;
  String? validateUsername(String? value) {
    if (value!.isEmpty) {
      return 'Email Field must not be empty';
    } else {
      if (validateEmail(value)) {
        return null;
      } else {
        return 'Email Field must be valid';
      }
    }
  }

  bool validateEmail(String email) {
    String pattern =
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'Password Field must not be empty';
    } else if (value.length < 8) {
      return 'Password must be of 8 or more digit';
    } else {
      return null;
    }
  }

  // {"DATEOFBIRTH":"1999-10-30","DateofBirth":"1999-10-30","FIRSTNAME":"DEOGRASS","FirstName":"DEOGRASS","LastName":"WIDAMBE","MIDDLENAME":"ELIUD","MiddleName":"ELIUD","NATIONALITY":"TANZANIAN","NIN":"19991030451110000125","NationalIDNumber":"19991030451110000125","Nationality":"NA-170","SEX":"MALE","SURNAME":"WIDAMBE","Sex":"MALE"}
  fetchNidaInfo() async {
    if (ninController.text.isNotEmpty) {
      setState(() {
        loadingNidaInfo = true;
      });
      try {
        print("=================================");
        var nidaInfos = await CallApi()
            .nidaInfoRequested("", "?nida_no=${ninController.text}", "get");
        var nidaInfo = json.decode(nidaInfos);
        // 19991030451110000125
        if (nidaInfo.containsKey('FirstName') &&
            nidaInfo.containsKey('LastName') &&
            nidaInfo.containsKey('Sex') &&
            nidaInfo.containsKey('NationalIDNumber') &&
            nidaInfo.containsKey('DateofBirth')) {
          // Populate form fields with NIDA information
          firstNameController.text = nidaInfo['FirstName'];
          lastNameController.text = nidaInfo['LastName'];
          sexController.text = nidaInfo['Sex'];
          ninController.text = nidaInfo['NationalIDNumber'];
          dobController.text = nidaInfo['DateofBirth'];
          userNameController.text =
              (nidaInfo['LastName'] ?? '') + (nidaInfo['FirstName'] ?? '');
          middleNameController.text = nidaInfo['MiddleName'] ?? '';
        } else {
          // Handle case where necessary fields are missing in the response
          await Fluttertoast.showToast(
            msg: "Invalid Nida No. or incomplete information",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
        // if (nidaInfo) {
        //   firstNameController.text = nidaInfo['FirstName'];
        //   lastNameController.text = nidaInfo['LastName'];
        //   sexController.text = nidaInfo['Sex'];
        //   ninController.text = nidaInfo['NationalIDNumber'];
        //   dobController.text = nidaInfo['DateofBirth'];
        //   userNameController.text =
        //       nidaInfo['LastName'] + nidaInfo['FirstName'];
        //   middleNameController.text = nidaInfo['MiddleName'];
        // } else {
        //   await Fluttertoast.showToast(
        //       msg: "Invalid Nida No.",
        //       toastLength: Toast.LENGTH_SHORT,
        //       gravity: ToastGravity.BOTTOM,
        //       timeInSecForIosWeb: 1,
        //       backgroundColor: Colors.red,
        //       textColor: Colors.white,
        //       fontSize: 16.0);
        // }
      } catch (e) {
        print(e);
        await Fluttertoast.showToast(
            msg: "Failed to fetch Nida info check your network!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } finally {
        setState(() {
          loadingNidaInfo = false;
        });
      }
    }
  }

  _userRegisterFnc() async {
    if (firstNameController.text.isEmpty && firstNameController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Fetch the NIDA information first before registering!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orangeAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    var data = {
      "first_name": firstNameController.text,
      "middle_name": middleNameController.text,
      "last_name": lastNameController.text,
      "user_password": userPasswordController.text,
      "email": userEmailController.text,
      "phone": userPhoneController.text,
      "dob": dobController.text,
      "gender": sexController.text,
      "nida_no": ninController.text,
      "role": 3,
    };

    print(data);
    setState(() {
      isLoading = true;
    });
    try {
      var res = await CallApi().authenticatedRequest(
          data, AppConstants.apiUserRegistration, 'post', "");
      print(res);
      var body = json.decode(res);

      if (body['message'] == "user created succesfully") {
        Fluttertoast.showToast(
            msg: "Jamii pass registration completed Successful!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      } else {
        await Fluttertoast.showToast(
            msg: "Registration failed!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (error) {
      Fluttertoast.showToast(
          msg: "Registration failed check network and try again!",
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
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
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
                        getTranslated(context, "register_title").toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: ninController,
                              // validator: validateUsername,
                              keyboardType: TextInputType.text,
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
                                hintText: 'Nida no.',
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
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Material(
                            borderRadius: BorderRadius.circular(14.0),
                            elevation: 0,
                            child: Container(
                              height: 46,
                              width: 100,
                              decoration: BoxDecoration(
                                color: AppColors.mainColor,
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () async {
                                    await fetchNidaInfo();

                                    // LoadingSpinner.showLoadingSpinner(context,
                                    //     text: "Fetching Nida info...");
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) => const MenuPageScreen()),
                                    // );
                                  },
                                  borderRadius: BorderRadius.circular(14.0),
                                  child: Center(
                                    child: Text(
                                      loadingNidaInfo
                                          ? "Loading.."
                                          : getTranslated(context, "nida_btn")
                                              .toString(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 46,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.blueGrey.withOpacity(0.07),
                        ),
                        child: Center(
                          child: Text(
                            firstNameController.text == ""
                                ? "Full name"
                                : "${firstNameController.text} ${lastNameController.text}",
                            style: TextStyle(
                              color: Colors.black12,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: userEmailController,
                        validator: validateUsername,
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
                          hintText: 'Email',
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
                        height: 30,
                      ),
                      TextFormField(
                        controller: userPhoneController,
                        // validator: validateUsername,
                        keyboardType: TextInputType.phone,
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
                          hintText: getTranslated(context, "register_phone")
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
                        height: 30,
                      ),
                      TextFormField(
                        controller: userPasswordController,
                        obscureText: true,
                        validator: validatePassword,
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
                          hintText: getTranslated(context, "register_password")
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
                        onTap: () {
                          _userRegisterFnc();
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => const MenuPageScreen()),
                          // );
                        },
                        borderRadius: BorderRadius.circular(14.0),
                        child: Center(
                          child: Text(
                            isLoading
                                ? "Loading....."
                                : getTranslated(context, "register_register")
                                    .toString(),
                            style: TextStyle(color: Colors.white),
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
                      getTranslated(context, "register_already").toString(),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()));
                      },
                      child: Text(
                        getTranslated(context, "register_click").toString(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
