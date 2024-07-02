import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../constants/custom_colors.dart';
import '../widgets/app_large_text.dart';
import '../widgets/app_small_text.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String version = '1.0.0';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.buttonBackground,
      appBar: AppBar(
        backgroundColor: AppColors.buttonBackground,
        title: AppLargeText(text: "About", size: 16),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.asset('assets/logo.png', height: 100),
                const SizedBox(height: 20),
                AppLargeText(text: "About JamiiPass", size: 24, color: Colors.black),
                const SizedBox(height: 10),
                AppSmallText(
                  text: "Version 1.0.0",
                  size: 14,
                  color: Colors.grey,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Welcome to our app, a pioneering digital identities ecosystem leveraging blockchain technology. Our mission is to revolutionize how identities are managed and shared in Tanzania by providing a secure and efficient platform for both users and organizations. Our app allows users to request and share digital identities seamlessly, ensuring privacy and security through the use of cutting-edge blockchain solutions.",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Key Features:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 10),
                const Text(
                  "- Secure identity sharing\n"
                  "- Blockchain-based security\n"
                  "- Easy-to-use interface\n"
                  "- Comprehensive privacy controls\n"
                  "- Seamless integration with organizations",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Our Commitment:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 10),
                const Text(
                  "We are committed to providing a secure, efficient, and user-friendly platform that empowers individuals and organizations to manage digital identities with confidence. Our team continuously works on enhancing the app, adding new features, and ensuring top-notch security to meet the evolving needs of our users.",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
