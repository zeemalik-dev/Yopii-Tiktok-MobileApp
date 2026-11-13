import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

class AppToast {
  static void success(BuildContext context, String message) {
    MotionToast.success(
      title: const Text(
        "Success",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(
        message,
        style: const TextStyle(color: Colors.white70),
      ),
      width: 340,
      height: 80,
      borderRadius: 20,
      iconSize: 36,
      animationType: AnimationType.slideInFromBottom,
      animationDuration: const Duration(milliseconds: 900),
      toastDuration: const Duration(seconds: 3),
      toastAlignment: Alignment.bottomCenter,
      // primaryColor: Colors.greenAccent.shade400,
      // backgroundType: BackgroundType.solid,
      barrierColor: Colors.transparent,
    ).show(context);
  }

  static void error(BuildContext context, String message) {
    MotionToast.error(
      title: const Text(
        "Error",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(
        message,
        style: const TextStyle(color: Colors.white70),
      ),
      width: 340,
      height: 80,
      borderRadius: 20,
      iconSize: 36,
      animationType: AnimationType.slideInFromBottom,
      animationDuration: const Duration(milliseconds: 900),
      toastDuration: const Duration(seconds: 5),
      toastAlignment: Alignment.bottomCenter,
      // primaryColor: Colors.redAccent.shade400,
      // backgroundType: BackgroundType.solid,
      barrierColor: Colors.transparent,
    ).show(context);
  }

  static void warning(BuildContext context, String message) {
    MotionToast.warning(
      title: const Text(
        "Warning",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(
        message,
        style: const TextStyle(color: Colors.white70),
      ),
      width: 340,
      height: 80,
      borderRadius: 20,
      iconSize: 36,
      animationType: AnimationType.slideInFromBottom,
      animationDuration: const Duration(milliseconds: 900),
      toastDuration: const Duration(seconds: 3),
      toastAlignment: Alignment.bottomCenter,
      // primaryColor: Colors.orangeAccent.shade400,
      // backgroundType: BackgroundType.solid,
      barrierColor: Colors.transparent,
    ).show(context);
  }
}
