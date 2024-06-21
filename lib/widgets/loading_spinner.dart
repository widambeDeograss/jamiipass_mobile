import 'package:flutter/material.dart';
import 'package:jamiipass_mobile/constants/custom_colors.dart';
import 'package:jamiipass_mobile/widgets/app_small_text.dart';

class LoadingSpinner {
  static showLoadingSpinner(BuildContext context,
      {String text = 'Loading...'}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Stack(
            children: [
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Container(
                  width: 200,
                  height: 80,
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(11))),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const CircularProgressIndicator(
                            color: AppColors.mainColor,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AppSmallText(
                            text: text,
                            size: 12,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}
