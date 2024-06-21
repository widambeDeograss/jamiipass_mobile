import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jamiipass_mobile/nav/main_page.dart';
import 'package:jamiipass_mobile/providers/default_provider.dart';
import 'package:jamiipass_mobile/providers/user_management_provider.dart';
import 'package:jamiipass_mobile/screens/all_identities.dart';
import 'package:jamiipass_mobile/screens/auth/otp_verification.dart';
import 'package:jamiipass_mobile/screens/auth/user_login.dart';
import 'package:jamiipass_mobile/screens/auth/user_registration.dart';
import 'package:jamiipass_mobile/screens/identity_request.dart';
import 'package:jamiipass_mobile/screens/identity_shares.dart';
import 'package:jamiipass_mobile/screens/select_language.dart';
import 'package:jamiipass_mobile/screens/select_organization.dart';
import 'package:jamiipass_mobile/screens/splash_screens.dart';
import 'package:jamiipass_mobile/screens/update_corp_profile.dart';
import 'package:jamiipass_mobile/screens/update_profile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'configs/langConfg/localization/app_localization.dart';
import 'constants/app_constants.dart';
import 'shared-preference-manager/preference_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => DefaultProvider()),
      ChangeNotifierProvider(create: (context) => UserAuthProvider()),
    ],
    child: MyApp(isFirstTime: isFirstTime),
  ));
}

class MyApp extends StatefulWidget {
  final bool isFirstTime;

  const MyApp({super.key, required this.isFirstTime});

  // For Language
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
  // Here

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // For Language
  bool isFirstTimeUser = true;
  Future<void> checkFirstTimeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTimeUser') ?? true;
    setState(() {
      isFirstTimeUser = isFirstTime;
    });
  }

  var language;
  @override
  void initState() {
    super.initState();
    initialLocale();
    checkFirstTimeUser();
  }

  Locale _locale = const Locale('en', 'US');
  void setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  Future<void> initialLocale() async {
    await getLanguage();
    if (language == 'swahili') {
      setState(() {
        _locale = const Locale('sw', 'SW');
      });
    } else {
      setState(() {
        _locale = const Locale('en', 'US');
      });
    }
  }

  getLanguage() async {
    var sharedPref = SharedPreferencesManager();
    var _language = await sharedPref.getString(AppConstants.language);
    setState(() {
      language = _language;
    });
  }
  // Here

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [Locale('sw', 'SW'), Locale('en', 'US')],
      localizationsDelegates: const [
        AppLocalization.delegate,
        //DELEGATES TRANSLATE TO ANOTHER
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        for (var locale in supportedLocales) {
          if (locale.languageCode == deviceLocale!.languageCode &&
              locale.countryCode == deviceLocale.countryCode) {
            return deviceLocale;
          }
        }
        return supportedLocales.first;
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: isFirstTimeUser ? '/select_language' : '/main',
      routes: {
        '/select_language': (context) =>
            LanguagePopupCard(onFirstTimeInit: _onFirstTimeInit),
        '/welcome': (context) => WelcomePage(onFirstTimeInit: _onFirstTimeInit),
        '/login': (context) => const LoginScreen(),
        '/otp': (context) => const OtpScreen(),
        '/register': (context) => const RegisterScreen(),
        '/main': (context) => const MainPage(),
        '/identities': (context) => const IdentitiesScreen(),
        '/identity_shares': (context) => const IdentitySharesScreen(),
        '/request_identity_select_org': (context) =>
            const SelectOrganizationForIdRequest(),
        '/request_identify': (context) => const IdentityRequestScr(),
        '/update_profile': (context) => const UpdateProfileScreen(),
        '/update_corporate_profile': (context) => const UpdateCorporateProfile(),
      },
    );
  }

  void _onFirstTimeInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTimeUser', false);
  }
}
