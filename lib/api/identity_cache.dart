import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../constants/app_constants.dart';

class IdentityCache {
  static final IdentityCache _instance = IdentityCache._internal();
  List<Map<String, dynamic>>? _cache;
  DateTime? _cacheTime;
  final Duration _cacheDuration = Duration(minutes: 10);

  factory IdentityCache() {
    return _instance;
  }

  IdentityCache._internal();

  void setCache(List<Map<String, dynamic>> data) {
    _cache = data;
    _cacheTime = DateTime.now();
  }

  List<Map<String, dynamic>>? getCache() {
    if (_cache != null && _cacheTime != null) {
      if (DateTime.now().difference(_cacheTime!) < _cacheDuration) {
        return _cache;
      }
    }
    _cache = null;
    _cacheTime = null;
    return null;
  }
}

Future<List<Map<String, dynamic>>> fetchIdentityData(String url) async {
  final cachedData = IdentityCache().getCache();
  if (cachedData != null) {
    return cachedData;
  }
 print(url);
  var networkLoginData = {"username": "NHIFadm", "orgName": "NHIFOrg"};
  var loginResponse = await http.post(
    Uri.parse(AppConstants.apiBaseUrl + AppConstants.networkLogin),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(networkLoginData),
  );


  if (loginResponse.statusCode == 200) {
    print("---------------------------");
    final loginData = json.decode(loginResponse.body);
    final networkToken = loginData['message']['token'];

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $networkToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
     final data = json.decode(response.body);
      final List<dynamic> datas = data['result'];
      
      if (datas != null) {
        final List<Map<String, dynamic>> identityData =
            datas.map((item) => item as Map<String, dynamic>).toList();
        
        IdentityCache().setCache(identityData);
        return identityData;
      } else {
        Fluttertoast.showToast(
          msg: "Error: No data found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        throw Exception('No data found');
      }
    } else {
      Fluttertoast.showToast(
        msg: "Error: Failed to load identity data",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception('Failed to load identity data');
    }
  } else {
    Fluttertoast.showToast(
      msg: "Error: Invalid login credentials",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    throw Exception('Failed to get network token');
  }
}


Future<Map<String, dynamic>> fetchIdentityDataWithTransactionId(String url) async{
    print(url);
  var networkLoginData = {"username": "NHIFadm", "orgName": "NHIFOrg"};
  var loginResponse = await http.post(
    Uri.parse(AppConstants.apiBaseUrl + AppConstants.networkLogin),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(networkLoginData),
  );
     if (loginResponse.statusCode == 200) {
    print("---------------------------");
    final loginData = json.decode(loginResponse.body);
    final networkToken = loginData['message']['token'];

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $networkToken',
        'Content-Type': 'application/json',
      },
    );

      if (response.statusCode == 200) {
     final data = json.decode(response.body);
      final Map<String, dynamic> datas = data['result'];
      
      if (datas != null) {
        final Map<String, dynamic> identityData =datas;

        return identityData;
      } else {
        Fluttertoast.showToast(
          msg: "Error: No data found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        throw Exception('No data found');
      }
    } else {
      Fluttertoast.showToast(
        msg: "Error: Failed to load identity data",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception('Failed to load identity data');
    }
   } else {
    Fluttertoast.showToast(
      msg: "Error: Invalid login credentials",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    throw Exception('Failed to get network token');
  }
}