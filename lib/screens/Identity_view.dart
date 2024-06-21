import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jamiipass_mobile/api/identity_cache.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../constants/custom_colors.dart';
import '../providers/user_management_provider.dart';
import '../widgets/app_large_text.dart';
import '../widgets/app_small_text.dart';

class ViewIdentityFile extends StatefulWidget {
  final transactionId;
  const ViewIdentityFile({super.key, this.transactionId});

  @override
  State<ViewIdentityFile> createState() => _ViewIdentityFileState();
}

class _ViewIdentityFileState extends State<ViewIdentityFile> {
  Map<String, dynamic> identityData = {};
  bool isLoading = true;
  Uint8List? pdfBytes;


  Future<void> loadDocument() async {
    print("object===================");
       print(identityData['documentHash']);
    try {
      // Decode the base64 string to bytes
      pdfBytes = base64Decode(identityData['documentHash']);

      // Set the state to trigger a rebuild
      setState(() {});
    } catch (error) {
      print('Error loading document: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
        isLoading = true;
      });
    try {
      final data = await fetchIdentityDataWithTransactionId(
          "${AppConstants.apiBaseUrl}${AppConstants.getIdentitiesFromNtwork}?fcn=GetIdentityByTransactionID&&args=${widget.transactionId}");
        print(data);
      setState(() {
        identityData = data;
        isLoading = false;
      });
            loadDocument();
      
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: "Error: Failed to fetch data",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: AppColors.buttonBackground,
        appBar: AppBar(
          backgroundColor: AppColors.buttonBackground,
          title: AppLargeText(
            text: "${widget.transactionId}",
            size: 16,
          ),
        ),
        body: isLoading
              ? Center(
                  child: AppSmallText(
                    text: "Loading....",
                  ),
                )
              :Center(
                child: pdfBytes != null
                    ? PDFView(
                  pdfData: pdfBytes!,
                  pageFling: true,
                  pageSnap: true,
                )
                    : const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
        );
      
  }
}