import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jamiipass_mobile/api/api.dart';
import 'package:jamiipass_mobile/constants/app_constants.dart';
import 'package:jamiipass_mobile/model/corporate_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../configs/langConfg/localization/localization_constants.dart';
import '../constants/custom_colors.dart';
import '../providers/user_management_provider.dart';

class UpdateCorporateProfile extends StatefulWidget {
  const UpdateCorporateProfile({Key? key}) : super(key: key);

  @override
  State<UpdateCorporateProfile> createState() => _UpdateCorporateProfileState();
}

class _UpdateCorporateProfileState extends State<UpdateCorporateProfile> {
  TextEditingController companyNameController = TextEditingController();
  TextEditingController companyEmailController = TextEditingController();
  TextEditingController companyPhoneController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  XFile? _image;
  final picker = ImagePicker();
  bool isLoading = false;
  bool isPicLoading = false;
  bool isPasswordEditing = false;
  String? profileUrl = "";

  void setProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      profileUrl = prefs.getString("corporate_file");
    });
  }

  @override
  void initState() {
    super.initState();
    setProfile();
    final corporateAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);
    Corporate corporate = corporateAuthProvider.authState.corporate;
    companyNameController.text = corporate.name!;
    companyEmailController.text = corporate.email!;
    companyPhoneController.text = corporate.phone!;
  }

  Future<void> _uploadProfilePic() async {
    final corporateAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Corporate corporate = corporateAuthProvider.authState.corporate;
    if (_image == null) return;
    setState(() {
      isPicLoading = true;
    });

    final String URL =
        "${AppConstants.apiBaseUrl}app/corp/update/${corporate.id}/profile";

    final response = await CallApi().uploadWithFile(
        {"files": await MultipartFile.fromFile(_image!.path)}, URL);

    if (response['success']) {
      Fluttertoast.showToast(
          msg: "Profile picture updated successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      prefs.setString('corporate_file', response['corporate']['profile']);
      setState(() {});
    } else {
      Fluttertoast.showToast(
          msg: "Error: Failed to update profile picture",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    setState(() {
      isPicLoading = false;
    });
  }

  Future<void> _updateProfile() async {
    final corporateAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);
    Corporate corporate = corporateAuthProvider.authState.corporate;
    setState(() {
      isLoading = true;
    });

    final String URL =
        "${AppConstants.apiBaseUrl}app/corp/update/${corporate.id}";
    final response = await http.post(
      Uri.parse(URL),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': companyNameController.text,
        'email': companyEmailController.text,
        'phone': companyPhoneController.text,
      }),
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Profile updated successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Error: Failed to update profile",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        _image = image;
        _uploadProfilePic();
      }
    });
  }

  void _togglePasswordEditing() {
    setState(() {
      isPasswordEditing = !isPasswordEditing;
    });
  }

  Future<void> _updatePassword() async {
    final corporateAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);
    Corporate corporate = corporateAuthProvider.authState.corporate;

    String oldPassword = oldPasswordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    final String URL =
        "${AppConstants.apiBaseUrl}app/corp/update/${corporate.id}/password";
    final response = await http.post(
      Uri.parse(URL),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'old_password': oldPassword,
        'new_password': confirmPassword,
      }),
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Password updated successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      oldPasswordController.clear();
      confirmPasswordController.clear();

      setState(() {
        isPasswordEditing = false;
      });
    } else {
      Fluttertoast.showToast(
        msg: "Error: Failed to update password",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    setState(() {
      isLoading = false;
    });
  }



  

  @override
  Widget build(BuildContext context) {
    final corporateAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);
    Corporate corporate = corporateAuthProvider.authState.corporate;

    return Scaffold(
      backgroundColor: AppColors.buttonBackground,
      appBar: AppBar(
        backgroundColor: AppColors.buttonBackground,
        title: Text(
          getTranslated(context, "profile_edit").toString(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: isPicLoading
                          ? const CircularProgressIndicator(
                              color: AppColors.mainColor,
                            )
                          : Image(
                              image: NetworkImage(
                                  "${AppConstants.mediaBaseUrl}/$profileUrl"),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.blue,
                        ),
                        child: const Icon(Icons.camera,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: companyNameController,
                      decoration: const InputDecoration(
                        labelText: "Corporate Name",
                        prefixIcon: Icon(Icons.business),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: companyEmailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.mail),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: companyPhoneController,
                      decoration: const InputDecoration(
                        labelText: "Phone No",
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          side: BorderSide.none,
                          shape: const StadiumBorder(),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 1,
                              )
                            : Text(
                                getTranslated(context, "profile_edit")
                                    .toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (isPasswordEditing)
                      Column(
                        children: [
                          TextFormField(
                            controller: oldPasswordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: "Old Password",
                              prefixIcon: Icon(Icons.lock),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: confirmPasswordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: "New Password",
                              prefixIcon: Icon(Icons.lock),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _updatePassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                side: BorderSide.none,
                                shape: const StadiumBorder(),
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 1,
                                    )
                                  : Text(
                                      "Change Password",
                                      style: const TextStyle(
                                          color: Colors.white),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text.rich(
                          TextSpan(
                            text: "",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _togglePasswordEditing,
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.redAccent.withOpacity(0.1),
                              elevation: 0,
                              foregroundColor: Colors.red,
                              shape: const StadiumBorder(),
                              side: BorderSide.none),
                          child: Text(isPasswordEditing
                              ? "Cancel"
                              : "Edit Password"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
