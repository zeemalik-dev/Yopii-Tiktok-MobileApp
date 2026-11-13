import 'package:createex_task_application/cors/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomToast {
  static void show(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 2),
  }) {
    final overlay = Overlay.of(context);
    // if (overlay == null) return;

    final overlayEntry = OverlayEntry(
      builder: (_) => Positioned(
        bottom: 80,
        left: 24,
        right: 24,
        child: AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 300),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            color: backgroundColor ?? Colors.black87,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null)
                    Icon(icon, color: AppColors.primaryWhite, size: 20),
                  if (icon != null) const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(
                          color: AppColors.primaryWhite, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}
