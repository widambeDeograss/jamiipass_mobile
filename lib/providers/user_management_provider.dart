import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jamiipass_mobile/api/api.dart';
import 'package:jamiipass_mobile/constants/app_constants.dart';
import 'package:jamiipass_mobile/model/corporate_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/auth_state.dart';
import '../model/user_model.dart';

class UserAuthProvider extends ChangeNotifier {
  AuthState _authState = AuthState(
      user: const User(null, null, null, null, null, null,null,null),
      corporate: Corporate(null, null, null, null, null, null));

  UserAuthProvider() {
    _authState = AuthState(
      user: const User(null, null, null, null, null, null,null,null),
      corporate: Corporate(null, null, null, null, null, null),
    ); // Initialize with default values

    // Fetch authentication state from shared preferences
    _fetchAuthStateFromStorage().then((authState) {
      _authState = authState;
      notifyListeners(); // Notify listeners after state update
    });
  }

  AuthState get authState => _authState;

  Future<AuthState> _fetchAuthStateFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    final String? userId = prefs.getString('userId');
    final String? username = prefs.getString('userName');
    final String? phone = prefs.getString('phone');
    final String? firstName = prefs.getString('firstName');
    final String? lastName = prefs.getString('lastName');
    final String? apiToken = prefs.getString('apiToken');
    final String? email = prefs.getString('email');
    final String? id = prefs.getString('corp_id');
    final String? userFile = prefs.getString('user_file');
    final String? corpName = prefs.getString('corp_name');
    final String? corpEmail = prefs.getString('corp_email');
    final String? corpFile = prefs.getString('corp_file');
    final String? corpPhone = prefs.getString('corp_phone');
    final String? corpApitoken = prefs.getString('corp_apiToken');
    final String? isCorp = prefs.getString('isCorp');

    if (isAuthenticated || corpApitoken != null || apiToken != null) {
      return AuthState(
          user: User(
            userId,
            username,
            email!,
            firstName!,
            lastName!,
              apiToken!,
            phone!,
            userFile
          ),
          corporate: Corporate(
              id, corpName, corpEmail, corpPhone, corpFile, corpApitoken),
          isAuthenticated: true,
          isCorp: isCorp);
    } else {
      return AuthState(
          user: const User(null, null, null, null, null, null,null,null),
          corporate: Corporate(null, null, null, null, null, null),
          isAuthenticated: false);
    }
  }

  Future<bool> loginUser(String userId, var otp) async {
    final body = {"user_id": userId, 'otp': otp};
    print(body);
    try {
      final response = await CallApi().authenticatedRequest(
          body, AppConstants.apiUserVerifyOtp, "post", "");
      print(response);
      var responseBody = json.decode(response);
      if (responseBody['success']) {
        final String userFName = responseBody['user']['first_name'];
        final String userLName = responseBody['user']['last_name'];
        final String userMName = responseBody['user']['nida_no'];
        final String userPhone = responseBody['user']['phone'];
        print(responseBody['user']['first_name']);
        final String userId = responseBody['user']
            ['user_id']; // Assuming the user ID is returned in the response

        final String userFile = responseBody['user']['profile'];
        final String userEmail = responseBody['user']['email'];
        final String userToken = responseBody['token'];
        // Save user details to shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isAuthenticated', true);
        prefs.setString('firstName', userFName);
        prefs.setString('lastName', userLName);
        prefs.setString('userName', userMName);
        prefs.setString('userId', userId);
        prefs.setString('user_file', userFile);
        prefs.setString('email', userEmail);
        prefs.setString('phone', userPhone);
        prefs.setString('apiToken', userToken);
        prefs.setString('isCorp', "citizen");

        // Update auth state
        _authState = AuthState(
            user: User(
              userId,
              userMName,
              userEmail,
              userFName,
              userLName,
                userToken,
              userPhone,
              userFile
            ),
            isAuthenticated: true,
            corporate: Corporate(null, null, null, null, null, null),
            isCorp: "citizen");

        notifyListeners();
        return true;
      } else {
        throw Exception('Failed to authenticate corp');
      }

      return true;
    } catch (error) {
      print('Error during login: $error');
      rethrow;
    }
  }

  Future<bool> loginCorp(String corpId, var otp) async {
    // Call your user authentication endpoint
    // For now, let's assume authentication was
    // final body = jsonEncode({"corp_id": corpId, 'otp': otp});
    var body = {"corp_id": corpId, "otp": otp};
    try {
      final response = await CallApi().authenticatedRequest(
          body, AppConstants.apiCorpVerifyOtp, "post", "");
      print(response);
      var responseBody = json.decode(response);
      if (responseBody['success']) {
        print("-------------------------");
        final String corpId = responseBody['corp']
            ['corp_id']; // Assuming the user ID is returned in the response
        final String corpName = responseBody['corp']
            ['corp_name']; // Assuming the user name is returned in the response
        final String corpPhone = responseBody['corp']['phone'];
        final String corpFile = responseBody['corp']['pic'];
        final String corpEmail = responseBody['corp']['email'];
        final String corpToken = responseBody['token'];
        // Save user details to shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isAuthenticated', true);
        prefs.setString('corp_name', corpName);
        prefs.setString('corp_id', corpId);
        prefs.setString('corp_email', corpEmail);
        prefs.setString('corp_phone', corpPhone);
        prefs.setString('corp_apiToken', corpToken);
        prefs.setString('corp_file', corpFile);
        prefs.setString('isCorp', "corp");

        // Update auth state
        _authState = AuthState(
            user: const User(null, null, null, null, null, null, null,null),
            isAuthenticated: true,
            corporate: Corporate(
                corpId, corpName, corpEmail, corpPhone, corpFile, corpToken),
            isCorp: "corp");

        notifyListeners();
        return true;
      } else {
        throw Exception('Failed to authenticate corp');
      }
    } catch (error) {
      print('Error during login: $error');
      rethrow;
    }
  }

  Future<void> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    _authState = AuthState(
        user: const User(null, null, null, null, null, null, null,null),
        corporate: Corporate(null, null, null, null, null, null),
        isAuthenticated: false);
    notifyListeners();
  }
}
