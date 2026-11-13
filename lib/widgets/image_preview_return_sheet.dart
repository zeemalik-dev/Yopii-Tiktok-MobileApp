import 'dart:io';
import 'package:flutter/material.dart';
import '../../../cors/theme/app_colors.dart';
import '../../../cors/utils/bottom_sheet_service.dart';

class ImagePreviewReturnSheet extends StatelessWidget {
  final File file;

  const ImagePreviewReturnSheet({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.primaryWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ===== Top Bar =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () =>
                        BottomSheetService.instance.dismiss(context),
                  ),
                  const Spacer(),
                  const Text(
                    "Image Preview",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      // ✅ Return file and close bottom sheet
                      Navigator.pop(context, file);
                    },
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        color: AppColors.primaryOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),
            const SizedBox(height: 10),

            // ===== Image Preview =====
            Expanded(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    file,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
