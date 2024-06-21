import 'package:jamiipass_mobile/model/user_model.dart';

import 'corporate_model.dart';

class AuthState {
  final User user;
  final Corporate corporate;
  final bool isAuthenticated;
  final String? isCorp;

  AuthState(
      {required this.user,
      required this.corporate,
      this.isCorp = "citizen",
      this.isAuthenticated = false});
}
