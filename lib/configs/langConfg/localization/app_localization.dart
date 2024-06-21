import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalization {
  final Locale? locale;
  AppLocalization({this.locale});
  static AppLocalization? of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  late Map<String, String> _localizedValues;

  Future load() async {
    //here we load json files based on selected language and put in jsonStringValues
    String jsonStringValues = await rootBundle
        .loadString('lib/configs/langConfg/lang/${locale!.languageCode}.json');
//from that jsonStringValues  we create a mapp of jsonStrin
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    _localizedValues =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

//this will return the translated values
  String? getTranslatedValue(String key) {
    return _localizedValues[key];
  }

  static const LocalizationsDelegate<AppLocalization> delegate =
      _AppLocalizationDelegate();
}

class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const _AppLocalizationDelegate();
  @override
  bool isSupported(Locale locale) {
    return ['en', 'sw'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalization> load(Locale locale) async {
    AppLocalization localization = AppLocalization(locale: locale);
    //this load function call the load function above
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(_AppLocalizationDelegate old) => false;
}
