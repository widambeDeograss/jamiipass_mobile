import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import '../constants/custom_colors.dart';
import '../widgets/app_large_text.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
      body: SafeArea(child:SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Section'),
            tiles: [
              SettingsTile(
                title: const Text('Language'),
                description: const Text('English'),
                leading: const Icon(Icons.language),
                onPressed: (BuildContext context) {},
                ),
              SettingsTile.switchTile(
                initialValue: false,
                title: const Text('Use fingerprint'),
                leading: const Icon(Icons.fingerprint),
                onToggle: (bool value) {},
              ),
            ],
          ),
        ],
      )),
 );
  }
}