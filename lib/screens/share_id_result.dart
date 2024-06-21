import 'package:flutter/material.dart';
import 'package:jamiipass_mobile/nav/home_page.dart';
import 'package:jamiipass_mobile/nav/main_page.dart';
import 'package:jamiipass_mobile/widgets/app_small_text.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../configs/langConfg/localization/localization_constants.dart';
import '../constants/custom_colors.dart';
import '../widgets/app_large_text.dart';

class IdShareResults extends StatefulWidget {
  final List<Map<String, dynamic>> identities;
  const IdShareResults({super.key, required this.identities});

  @override
  State<IdShareResults> createState() => _IdShareResultsState();
}

class _IdShareResultsState extends State<IdShareResults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.buttonBackground,
      appBar: AppBar(
        backgroundColor: AppColors.buttonBackground,
        title: AppLargeText(
          text: "",
          size: 16,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Container(
                height: 200,
                width: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/tick.png"),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
              const SizedBox(height: 30),
              Text(
               getTranslated(context, "share_id_result").toString(),
               textAlign: TextAlign.center,
               style: TextStyle(fontSize: 13, ),
              ),
              const SizedBox(height: 30),
              Divider(),
              const SizedBox(height: 20),
              QrImageView(
                data: widget.identities.toString(),
                version: QrVersions.auto,
                size: 200.0,
              ),
              Divider(),
              const SizedBox(height: 20),
               SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    backgroundColor: AppColors.mainColor,
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(
                    //       10), // Set border radius here
                    // ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainPage(
                              )),
                    );
                  },
                  child: Text(
                    getTranslated(context, 'share_id_btn').toString(),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
