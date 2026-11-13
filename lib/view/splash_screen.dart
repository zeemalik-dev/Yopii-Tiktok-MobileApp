import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../controller/providers/auth_provider.dart';
import '../cors/routes/app_routes.dart';
import '../cors/theme/app_colors.dart'; // adjust import

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to next screen after delay
    _navigate();
  }

  Future<void> _navigate() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Wait a short splash delay
    await Future.delayed(const Duration(seconds: 3));

    // Initialize authentication check
    await authProvider.initAuth();

    // Navigate based on login status
    if (authProvider.isLoggedIn) {
      Get.offAllNamed(AppRoutes.home); // ✅ Direct to Home if logged in
    } else {
      Get.offAllNamed(AppRoutes.onboarding); // 🧭 Otherwise Onboarding
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // ✨ Background Gradient
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              AppColors.primaryOrange.withOpacity(0.9),
              AppColors.primaryWhite,
              AppColors.primaryYellow.withOpacity(0.7),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🟡 Center Logo
              Image.asset(
                'assets/images/yoopii_logo.png', // replace with your asset name
                height: 130,
                width: 130,
              ),

              const SizedBox(height: 25),

              // 🔁 Circular Progress Indicator
              const SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.primaryWhite),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
