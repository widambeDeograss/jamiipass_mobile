import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import '../constants/custom_colors.dart';
import '../widgets/app_large_text.dart';
import '../shared-preference-manager/preference_manager.dart';
import '../configs/langConfg/localization/localization_constants.dart';
import '../constants/app_constants.dart';
import '../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? language = 'English';

  void getLanguage() async {
    var sharedPref = SharedPreferencesManager();
    var locale = await sharedPref.getString(AppConstants.language);
    setState(() {
      language = locale == 'swahili' ? 'Swahili' : 'English';
    });
  }

  void showLanguageSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
           backgroundColor: AppColors.buttonBackground,
          title: Text(getTranslated(context, 'selectLanguage').toString()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RadioListTile(
                title: const Text("Swahili"),
                value: "swahili",
                groupValue: language?.toLowerCase(),
                onChanged: (value) {
                  setState(() {
                    language = 'Swahili';
                  });
                  MyApp.setLocale(context, const Locale("sw", 'SW'));
                  var sharedPref = SharedPreferencesManager();
                  sharedPref.saveString(AppConstants.language, "swahili");
                  Navigator.pop(context);
                },
              ),
              RadioListTile(
                title: const Text("English"),
                value: "english",
                groupValue: language?.toLowerCase(),
                onChanged: (value) {
                  setState(() {
                    language = 'English';
                  });
                  MyApp.setLocale(context, const Locale("en", 'US'));
                  var sharedPref = SharedPreferencesManager();
                  sharedPref.saveString(AppConstants.language, "english");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    getLanguage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.buttonBackground,
      appBar: AppBar(
        backgroundColor: AppColors.buttonBackground,
        title: AppLargeText(
          text: "Settings",
          size: 16,
        ),
      ),
      body: SafeArea(
        child: SettingsList(
          sections: [
            SettingsSection(
              title: const Text('Section'),
              tiles: [
                SettingsTile(
                  title: const Text('Language'),
                  description: Text(language ?? 'English'),
                  leading: const Icon(Icons.language),
                  onPressed: (BuildContext context) {
                    showLanguageSelectionDialog(context);
                  },
                ),
                // SettingsTile.switchTile(
                //   initialValue: false,
                //   title: const Text('Use fingerprint'),
                //   leading: const Icon(Icons.fingerprint),
                //   onToggle: (bool value) {},
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
