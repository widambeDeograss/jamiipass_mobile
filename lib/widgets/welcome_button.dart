import 'package:flutter/material.dart';

import '../constants/custom_colors.dart';
import 'app_small_text.dart';

class WelcomeButton extends StatelessWidget {
  bool isResponsive;
  double? width;
  WelcomeButton({Key? key, this.isResponsive = true, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: isResponsive ? double.maxFinite : width,
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.mainColor),
        child: Row(
          mainAxisAlignment: isResponsive
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.center,
          children: [
            isResponsive
                ? Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: AppSmallText(
                      text: "Continue",
                      color: Colors.white,
                    ),
                  )
                : Container(),
            // Image.asset("assets/img/button-one.png")
          ],
        ),
      ),
    );
  }
}
