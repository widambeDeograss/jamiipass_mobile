import 'package:flutter/material.dart';
import 'package:jamiipass_mobile/constants/custom_colors.dart';
import 'package:jamiipass_mobile/widgets/app_small_text.dart';

import '../configs/langConfg/localization/localization_constants.dart';
import '../constants/app_constants.dart';
import '../main.dart';
import '../shared-preference-manager/preference_manager.dart';

class LanguagePopupCard extends StatefulWidget {
  const LanguagePopupCard({Key? key, required void Function() onFirstTimeInit})
      : super(key: key);

  @override
  State<LanguagePopupCard> createState() => _LanguagePopupCardState();
}

class _LanguagePopupCardState extends State<LanguagePopupCard> {
  String? language;
  void getLanguage() async {
    var sharedPref = SharedPreferencesManager();
    var locale = await sharedPref.getString(AppConstants.language);
    print(locale);
    if (locale == 'swahili') {
      setState(() {
        language = 'swahili';
      });
    } else {
      setState(() {
        language = 'english';
      });
    }
  }

  @override
  void initState() {
    getLanguage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.buttonBackground,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Hero(
            tag: "Language",
            child: Material(
              color: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 20, top: 5),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.language,
                              color: Colors.blue,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              getTranslated(context, 'selectLanguage')
                                  .toString(),
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        const Divider(),
                        RadioListTile(
                          title: const Text("Swahili"),
                          value: "swahili",
                          groupValue: language,
                          onChanged: (value) {
                            setState(() {
                              language = value.toString();
                            });
                            MyApp.setLocale(context, const Locale("sw", 'SW'));
                            var sharedPref = SharedPreferencesManager();
                            sharedPref.saveString(
                                AppConstants.language, "swahili");
                          },
                        ),
                        RadioListTile(
                          title: const Text("English"),
                          value: "english",
                          groupValue: language,
                          onChanged: (value) {
                            setState(() {
                              language = value.toString();
                            });
                            MyApp.setLocale(context, const Locale("en", 'US'));
                            var sharedPref = SharedPreferencesManager();
                            sharedPref.saveString(
                                AppConstants.language, "english");
                          },
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: AppColors.mainColor,
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(
                              //       10), // Set border radius here
                              // ),
                            ),
                            onPressed: () {
                              // Navigate to WelcomeScreen
                              Navigator.pushNamed(context, '/welcome')
                                  .then((value) {
                                // Call onFirstTimeInit when returning from WelcomeScreen
                              });
                            },
                            child: AppSmallText(
                              text: getTranslated(context, 'language_continue')
                                  .toString(),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
