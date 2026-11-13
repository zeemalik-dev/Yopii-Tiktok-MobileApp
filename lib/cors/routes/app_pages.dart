import 'dart:io';

import 'package:createex_task_application/model/user_model.dart';
import 'package:get/get.dart';

import '../../view/chat/chat_screen.dart';
import '../../view/content/post/post_screen.dart';
import '../../view/home_screen/home_screen.dart';
import '../../view/onboarding/onboarding_screen.dart';
import '../../view/profile/edit_profile/edit_profile_screen.dart';
import '../../view/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatScreen(),
    ),

    GetPage(
      name: AppRoutes.post,
      page: () {
        final file = Get.arguments as File; // receive file here
        return PostScreen(file: file);
      },
    ),

    GetPage(
      name: AppRoutes.editProfile,
      page: () {
        final userProfile = Get.arguments as User; // receive file here
        return EditProfileScreen(userProfile: userProfile);
      },
    ),
// Placeholder
  ];
}
