import 'package:flutter/material.dart';
import 'package:jamiipass_mobile/constants/custom_colors.dart';
import 'package:jamiipass_mobile/screens/scanner.dart';

import '../configs/langConfg/localization/localization_constants.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  GlobalKey _qrKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.buttonBackground,
      appBar: AppBar(
         automaticallyImplyLeading: false,
        backgroundColor: AppColors.buttonBackground,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Center(
              child: Image.asset(
                "assets/qrcode.png",
                height: 150,
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            Center(
              child: Text(
                getTranslated(context, "scan_page_title").toString(),
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ),
            Center(
              child: Text(
                getTranslated(context, "scan_page_Description").toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.black45),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QRViewExample(),
                    ));
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.mainColor,
              ),
              child: Text(
                getTranslated(context, "scan_page_Button").toString(),
                style: const TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
