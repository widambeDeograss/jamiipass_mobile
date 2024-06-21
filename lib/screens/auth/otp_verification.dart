import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jamiipass_mobile/constants/custom_colors.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../configs/langConfg/localization/localization_constants.dart';
import '../../nav/main_page.dart';
import '../../providers/user_management_provider.dart';

class OtpScreen extends StatefulWidget {
  final userId;
  final corpId;
  final isCorp;
  const OtpScreen({Key? key, this.isCorp, this.userId, this.corpId})
      : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  var verification = '';
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 76,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blueGrey,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.buttonBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                height: 100,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "JamiiPass",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                getTranslated(context, "otp_title").toString(),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                getTranslated(context, "otp_dsc").toString(),
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Pinput(
                length: 4,
                showCursor: true,
                autofocus: true,
                onCompleted: (pin) {
                  setState(() {
                    verification = pin;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 300,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: AppColors.mainColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      _verifyOtp();
                    },
                    child: Text(
                      getTranslated(context, "otp_btn").toString(),
                      style: const TextStyle(color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }

  _verifyOtp() async {
    final userAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);

    if (widget.isCorp == "corp") {
      print(widget.corpId);
      final response =
          await userAuthProvider.loginCorp(widget.corpId, verification);
      if (response) {
        Fluttertoast.showToast(
            msg: "Login to JamiiPass completed Successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MainPage(),
            ));
      } else {
        await Fluttertoast.showToast(
            msg: "Error: Invalid otp ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      try {
        final response =
            await userAuthProvider.loginUser(widget.userId, verification);
        if (response) {
          Fluttertoast.showToast(
              msg: "Login to JamiiPass completed Successfully!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MainPage(),
              ));
        } else {
          await Fluttertoast.showToast(
              msg: "Error: Invalid otp",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } catch (error) {
        print(error);
        await Fluttertoast.showToast(
            msg: "Error: Invalid otp check network and try again!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }
}
