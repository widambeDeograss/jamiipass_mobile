import 'package:flutter/material.dart';

import 'app_localization.dart';

String? getTranslated(BuildContext context, String key) {
  return AppLocalization.of(context)?.getTranslatedValue(key);
}
