import 'package:flutter/material.dart';

import '../constants/custom_colors.dart';
import '../widgets/app_large_text.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.buttonBackground,
      appBar: AppBar(
        backgroundColor: AppColors.buttonBackground,
        title: AppLargeText(text: "Privacy Policy", size: 16),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.asset('assets/logo.png', height: 100),
                const SizedBox(height: 20),
                AppLargeText(text: "Privacy Policy", size: 24, color: Colors.black),
                const SizedBox(height: 20),
                const Text(
                  "Your privacy is important to us. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our application. Please read this policy carefully to understand our views and practices regarding your personal data and how we will treat it.",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Information We Collect:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 10),
                const Text(
                  "- Personal identification information (NidaNo, Name, email address, phone number, etc.)\n"
                  "- Digital identity information\n"
                  "- Usage data\n"
                  "- Device data",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 20),
                const Text(
                  "How We Use Your Information:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 10),
                const Text(
                  "- To provide and maintain our service\n"
                  "- To manage your account\n"
                  "- To improve our app and services\n"
                  "- To communicate with you\n"
                  "- To ensure security and prevent fraud",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Sharing Your Information:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 10),
                const Text(
                  "We may share your information with third parties only in the following cases:\n"
                  "- With your consent\n"
                  "- Identity shares you approve\n"
                  "- For compliance with legal obligations\n"
                  "- To protect and defend our rights and property\n"
                  "- To prevent or investigate possible wrongdoing",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Your Rights:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 10),
                const Text(
                  "You have the right to access, correct, or delete your personal data. You also have the right to object to or restrict certain types of processing of your personal data. To exercise these rights, please contact us.",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Changes to This Policy:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 10),
                const Text(
                  "We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page. You are advised to review this Privacy Policy periodically for any changes.",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Contact Us:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 10),
                const Text(
                  "If you have any questions about this Privacy Policy, please contact us at support@jamiipass.com.",
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
