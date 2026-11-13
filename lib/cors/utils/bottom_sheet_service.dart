import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../theme/app_colors.dart';

/// 🧭 A singleton service to manage showing and dismissing modal bottom sheets.
/// Keeps UI logic clean and centralizes control for better code reuse.
class BottomSheetService {
  // 🔒 Private constructor for singleton
  BottomSheetService._internal();

  // 🌎 Single shared instance
  static final BottomSheetService _instance = BottomSheetService._internal();

  // 🚀 Public getter to access the instance
  static BottomSheetService get instance => _instance;

  /// 🧩 Show a Cupertino-style modal bottom sheet with consistent styling.
  ///
  /// [isDismissible] — If false, prevents the user from closing the sheet
  /// by tapping outside or swiping down.
  Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool expand = false,
    bool isDismissible = true,
    Color backgroundColor = AppColors.primaryWhite,
    double borderRadius = 25,
    Color barrierColor = const Color(0x55000000), // semi-transparent black
  }) {
    return showCupertinoModalBottomSheet<T>(
      context: context,
      expand: expand,
      barrierColor: barrierColor,
      enableDrag: isDismissible,
      isDismissible: isDismissible,
      builder: (_) => ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
        child: Material(
          color: backgroundColor,
          clipBehavior: Clip.none, // 👈 ALLOWS IMAGE OVERFLOW
          child: SafeArea(
            top: false, // avoid double padding
            child: child,
          ),
        ),
      ),
    );
  }

  /// 🧭 Dismiss the current modal bottom sheet safely.
  void dismiss(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}
