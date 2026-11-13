import 'dart:io';

import 'package:createex_task_application/view/content/preview/media_preview_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../cors/routes/app_routes.dart';
import '../../../cors/theme/app_colors.dart';
import '../../../cors/utils/bottom_sheet_service.dart';

class MediaPickerSheet extends StatelessWidget {
  const MediaPickerSheet({super.key});

  Future<void> _pickMedia(BuildContext context, ImageSource source,
      {required bool isVideo}) async {
    // Ask permission
    final status = await Permission.photos.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permission denied")),
      );
      return;
    }

    final picker = ImagePicker();
    XFile? file;

    if (isVideo) {
      file = await picker.pickVideo(source: source);
    } else {
      file = await picker.pickImage(source: source);
    }

    if (file != null && context.mounted) {
      BottomSheetService.instance.dismiss(context);

      BottomSheetService.instance.show(
          context: context,
          child: MediaPreviewSheet(
            file: File(file.path),
            isVideo: isVideo,
            onNextTap: () {
              // navigate to next screen with selected file
              BottomSheetService.instance.dismiss(context);

              Get.toNamed(AppRoutes.post, arguments: file);
            },
          ));

      // Navigator.pop(context); // Close sheet
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) => MediaPreviewScreen(
      //       file: File(file!.path),
      //       isVideo: isVideo,
      //     ),
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Choose from Gallery",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _optionButton(
                icon: Icons.image_outlined,
                label: "Image",
                color: Colors.blue,
                onTap: () =>
                    _pickMedia(context, ImageSource.gallery, isVideo: false),
              ),
              _optionButton(
                icon: Icons.videocam_outlined,
                label: "Video",
                color: Colors.redAccent,
                onTap: () =>
                    _pickMedia(context, ImageSource.gallery, isVideo: true),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _optionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 36),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: TextStyle(fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}
