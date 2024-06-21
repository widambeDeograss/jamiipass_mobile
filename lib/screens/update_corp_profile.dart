import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jamiipass_mobile/model/corporate_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api.dart';
import '../configs/langConfg/localization/localization_constants.dart';
import '../constants/app_constants.dart';
import '../constants/custom_colors.dart';
import '../model/user_model.dart';
import '../providers/user_management_provider.dart';
import 'package:dio/dio.dart';

class UpdateCorporateProfile extends StatefulWidget {
  const UpdateCorporateProfile({super.key});

  @override
  State<UpdateCorporateProfile> createState() => _UpdateCorporateProfileState();
}

class _UpdateCorporateProfileState extends State<UpdateCorporateProfile> {
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPhoneController = TextEditingController();
  TextEditingController corpName = TextEditingController();
  XFile? _image;
  final picker = ImagePicker();
  bool isLoading = false;
  bool isPicLoading = false;
   String? profileUrl = "";

  get http => null;
   void setProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      profileUrl = prefs.getString("corp_file");
    });
  
  }

  void initState() {
    super.initState();
      setProfile();
    final userAuthProvider = Provider.of<UserAuthProvider>(context, listen: false);
    Corporate corp = userAuthProvider.authState.corporate;
    userEmailController.text = corp.email!;
    userPhoneController.text = corp.phone!;
  }

  Future<void> _uploadProfilePic() async {
     final userAuthProvider = Provider.of<UserAuthProvider>(context, listen: false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
    Corporate corp = userAuthProvider.authState.corporate;
    if (_image == null) return;
    setState(() {
      isPicLoading = true;
    });

    final String URL = "${AppConstants.apiBaseUrl}app/corp/update/${corp.id}/pic";

print("======================${URL}================================");
       final response = await CallApi().uploadWithFile({"files": await MultipartFile.fromFile(_image!.path)}, URL);
       print(response);

    if (response['success']) {
      Fluttertoast.showToast(
          msg: "Profile picture updated successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
             
          print(response['corp']['pic']);
          prefs.setString('corp_file', response['corp']['pic']);
        
          setState(() {
            
          }); 
      print('Profile picture updated successfully');
    } else {
      Fluttertoast.showToast(
          msg: "Error:Failed to update profile picture",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      // Handle error
      print('Failed to update profile picture');
    }
    setState(() {
      isPicLoading = false;
    });
  }


  Future<void> _updateProfile() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.put(
      Uri.parse(AppConstants.apiBaseUrl + AppConstants.corpUpdateProfileInfo),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'corp_name':corpName.text,
        'email': userEmailController.text,
        'phone': userPhoneController.text,
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
      // Handle success
      print('Profile updated successfully');
    } else {
      Fluttertoast.showToast(
          msg: "Error:Failed to update profile",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      // Handle error
      print('Failed to update profile');
    }

    setState(() {
      isLoading = true;
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
  @override
  Widget build(BuildContext context) {
    final userAuthProvider =
    Provider.of<UserAuthProvider>(context, listen: false);
    Corporate corp = userAuthProvider.authState.corporate;
    return Scaffold(
      backgroundColor: AppColors.buttonBackground,
      appBar: AppBar(
        backgroundColor: AppColors.buttonBackground,
        title:
        Text(getTranslated(context, "profile_edit").toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // -- IMAGE with ICON
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: isPicLoading? const CircularProgressIndicator():
                         Image(
                          image: NetworkImage("${AppConstants.mediaBaseUrl}/${profileUrl}"),
                          fit: BoxFit.cover,
                        )),
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
                            color: Colors.blue),
                        child: const Icon(Icons.camera,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),

              // -- Form Fields
              Form(
                child: Column(
                  children: [
                    TextFormField(
                    controller: corpName,
                      decoration:  const InputDecoration(
                          label: Text("Corporate name"),
                          prefixIcon: Icon(Icons.person)),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: userEmailController,
                      decoration: const InputDecoration(
                          label: Text("Email"), prefixIcon: Icon(Icons.mail)),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: userPhoneController,
                      decoration: const InputDecoration(
                          label: Text("PhoneNo"),
                          prefixIcon: Icon(Icons.phone)),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        label: const Text("Password"),
                        prefixIcon: const Icon(Icons.fingerprint),
                        suffixIcon: IconButton(
                            icon: const Icon(Icons.remove_red_eye_outlined),
                            onPressed: () {}),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // -- Form Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _updateProfile,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            side: BorderSide.none,
                            shape: const StadiumBorder()),
                        child: isLoading? const CircularProgressIndicator():
                        const Text("EditProfile",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // -- Created Date and Delete Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text.rich(
                          TextSpan(
                            text: "Joined",
                            style: TextStyle(fontSize: 12),
                            children: [
                              TextSpan(
                                  text: "JoinedAt",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12))
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                              Colors.redAccent.withOpacity(0.1),
                              elevation: 0,
                              foregroundColor: Colors.red,
                              shape: const StadiumBorder(),
                              side: BorderSide.none),
                          child: const Text("Delete"),
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
