import 'package:createex_task_application/controller/providers/forgot_password_provider.dart';
import 'package:createex_task_application/controller/providers/post_provider.dart';
import 'package:createex_task_application/controller/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'controller/providers/auth_provider.dart';
import 'controller/providers/chat_provider.dart';
import 'controller/providers/feed_provider.dart';
import 'cors/routes/app_pages.dart';
import 'cors/routes/app_routes.dart';
import 'cors/theme/app_colors.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryWhite, // Top bar background color
        statusBarIconBrightness: Brightness.dark, // Icons: white for dark bg
        statusBarBrightness: Brightness.light, // For iOS
        systemStatusBarContrastEnforced: true),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FeedProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ForgotProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Yoopii',
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.primaryWhite,
          primarySwatch: Colors.deepOrange,
        ),
        initialRoute: AppRoutes.splash,
        getPages: AppPages.pages,
      ),
    );
  }
}
