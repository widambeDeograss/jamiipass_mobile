import 'package:flutter/material.dart';
import 'package:jamiipass_mobile/constants/custom_colors.dart';
import 'package:jamiipass_mobile/nav/corp_home.dart';
import 'package:provider/provider.dart';

import '../providers/user_management_provider.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'scan_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // List pages = [HomePage(), ScanPage(), ProfilePage()];

  List<Widget> pages = [
    // const HomePage(),
    // ScanPage(),
    // const ProfilePage()
  ]; // Initialize as empty list

  @override
  void initState() {
    super.initState();
    _updatePages(); // Call method to update pages list
  }

  void _updatePages() {
    final userAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);
    final userType = userAuthProvider.authState.isCorp;

    // Conditionally set pages list based on user type
    setState(() {
      if (userType == 'corp') {
        pages = [const CorporateHomeScreen(), ScanPage(), const ProfilePage()];
      } else {
        pages = [const HomePage(), ScanPage(), const ProfilePage()];
      }
    });
  }

  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: currentIndex,
        selectedItemColor: AppColors.mainColor,
        unselectedItemColor: Colors.grey.withOpacity(0.5),
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        onTap: onTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.apps), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.document_scanner), label: "Scan"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
        ],
      ),
    );
  }
}
