import 'package:flutter/material.dart';
import 'package:jamiipass_mobile/widgets/app_small_text.dart';

import '../configs/langConfg/localization/localization_constants.dart';
import '../constants/custom_colors.dart';
import '../widgets/app_large_text.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key, required void Function() onFirstTimeInit})
      : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  List<String> images = [
    "splash_2.png",
    "splash_3.png",
    "splash_4.png",
  ];

  @override
  Widget build(BuildContext context) {
    List welcomeTitles = [
      getTranslated(context, "welcomeTitle1").toString(),
      getTranslated(context, "welcomeTitle2").toString(),
      getTranslated(context, "welcomeTitle3").toString(),
    ];
    List welcomeTexts = [
      getTranslated(context, "welcomeText1").toString(),
      getTranslated(context, "welcomeText2").toString(),
      getTranslated(context, "welcomeText3").toString(),
    ];

    return Scaffold(
        body: PageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            itemBuilder: (_, index) {
              return Container(
                padding: const EdgeInsets.only(left: 30, right: 30),
                decoration:
                    const BoxDecoration(color: AppColors.buttonBackground),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/logo.png"),
                              fit: BoxFit.cover,
                            ),
                            // borderRadius: BorderRadius.all(Radius.circular(10)),
                            // boxShadow: List
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        AppLargeText(
                          text: "JamiiPass",
                          size: 22,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Container(
                          height: 300,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/${images[index]}"),
                              fit: BoxFit.fill,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(images.length, (slideIndex) {
                            return Container(
                              margin:
                                  const EdgeInsets.only(bottom: 2, right: 2),
                              width: index == slideIndex ? 25 : 23,
                              height: 7,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: index == slideIndex
                                      ? AppColors.mainColor
                                      : AppColors.mainColor.withOpacity(0.3)),
                            );
                          }),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: AppLargeText(
                            text: welcomeTitles[index] ?? '',
                            size: 20,
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: AppSmallText(
                            text: welcomeTexts[index] ?? '',
                            size: 14,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Container(
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
                              Navigator.pushNamed(context, '/login');
                            },
                            child: Text(
                              getTranslated(context, 'language_continue')
                                  .toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
            }));
  }
}
