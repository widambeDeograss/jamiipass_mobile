import 'package:flutter/material.dart';
import 'package:jamiipass_mobile/constants/app_constants.dart';
import 'package:jamiipass_mobile/constants/custom_colors.dart';
import 'package:jamiipass_mobile/screens/AboutScreen.dart';
import 'package:jamiipass_mobile/screens/PrivacyPolicy.dart';
import 'package:jamiipass_mobile/screens/settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../configs/langConfg/localization/localization_constants.dart';
import '../providers/user_management_provider.dart';
import '../widgets/log_out_dialog.dart';
import '../widgets/profile_menu.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
   String? profileUrl = "data";

  void setProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
        final userAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);
       final userType = userAuthProvider.authState.isCorp;
    setState(() {
      profileUrl = userType == "corp"? prefs.getString("corp_file"): prefs.getString("user_file");
    });
  
  }

    void initState() {
    super.initState();
    setProfile();
  }
  @override
  Widget build(BuildContext context) {
    final userAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);
    final corp = userAuthProvider.authState.corporate;
    final userType = userAuthProvider.authState.isCorp;
    final user = userAuthProvider.authState.user;

    return Scaffold(
      backgroundColor: AppColors.buttonBackground,
      
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.buttonBackground,
        title: Text(getTranslated(context, "profile_title").toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              /// -- IMAGE
              Stack(
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image(
                          image: profileUrl == null || profileUrl == ""
                              ? const NetworkImage(
                                  "https://www.freepik.com/free-vector/blue-circle-with-white-user_145857007.htm#query=user&position=0&from_view=keyword&track=sph&uuid=ef4ac314-a7a0-40bb-be40-7b05a4cb81e2")
                              : NetworkImage(
                                  "${AppConstants.mediaBaseUrl}/$profileUrl"),
                          fit: BoxFit.cover,
                        )),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: AppColors.mainColor),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              userType == 'corp'
                  ? Text("${corp.name}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal))
                  : Text("${user.firstName} ${user.lastName}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal)),
              userType == 'corp'
                  ? Text("${corp.email}",
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal))
                  : Text("${user.email}",
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.normal)),
              const SizedBox(height: 12),

              /// -- BUTTON
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => {
                    userType == 'corp'
                        ? Navigator.pushNamed(
                            context, '/update_corporate_profile')
                        : Navigator.pushNamed(context, '/update_profile')
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor,
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: Text(getTranslated(context, "profile_edit").toString(),
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              /// -- MENU
              ProfileMenuWidget(
                  title: getTranslated(context, "profile_settings").toString(),
                  icon: Icons.settings,
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsScreen()),
                    );
                  }),
              userType != "corp"
                  ? ProfileMenuWidget(
                      title: getTranslated(context, "profile_all_identities")
                          .toString(),
                      icon: Icons.wallet,
                      onPress: () {
                        Navigator.pushNamed(context, '/identities');
                      })
                  : const Text(""),
              ProfileMenuWidget(
                  title: getTranslated(context, "profile_share").toString(),
                  icon: Icons.verified_user,
                  onPress: () {
                    Navigator.pushNamed(context, '/identity_shares');
                  }),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                  title: getTranslated(context, "profile_policy").toString(),
                  icon: Icons.info,
                  onPress: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PrivacyPolicyScreen()),
                    );
                  }),
              ProfileMenuWidget(
                  title: getTranslated(context, "profile_about").toString(),
                  icon: Icons.approval_outlined,
                  onPress: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AboutScreen()),
                    );
                  }),
              ProfileMenuWidget(
                  title: getTranslated(context, "profile_logout").toString(),
                  icon: Icons.logout_outlined,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const LogoutDialog();
                      },
                    );
                    // Get.defaultDialog(
                    //   title: "LOGOUT",
                    //   titleStyle: const TextStyle(fontSize: 20),
                    //   content: const Padding(
                    //     padding: EdgeInsets.symmetric(vertical: 15.0),
                    //     child: Text("Are you sure, you want to Logout?"),
                    //   ),
                    //   confirm: Expanded(
                    //     child: ElevatedButton(
                    //       onPressed: () => AuthenticationRepository.instance.logout(),
                    //       style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, side: BorderSide.none),
                    //       child: const Text("Yes"),
                    //     ),
                    //   ),
                    //   cancel: OutlinedButton(onPressed: () => Get.back(), child: const Text("No")),
                    // );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
