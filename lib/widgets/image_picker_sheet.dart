import 'dart:io';
import 'package:createex_task_application/widgets/image_preview_return_sheet.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../cors/theme/app_colors.dart';
import '../../../cors/utils/bottom_sheet_service.dart';

class ProfileImagePickerSheet extends StatelessWidget {
  const ProfileImagePickerSheet({
    super.key,
  });

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    // ✅ Ask permission
    final cameraStatus = await Permission.camera.request();
    final galleryStatus = await Permission.photos.request();

    if (!cameraStatus.isGranted && !galleryStatus.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permission denied")),
      );
      return;
    }

    final picker = ImagePicker();
    final file = await picker.pickImage(source: source);

    if (file != null && context.mounted) {
      // ✅ Close this sheet

      // ✅ Show preview sheet, pass the same callback forward
      final profileImage = await BottomSheetService.instance.show(
        context: context,
        child: ImagePreviewReturnSheet(
          file: File(file.path),
        ),
      );

      Navigator.pop(context, profileImage);
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
            "Select Profile Image",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _optionButton(
                icon: Icons.image_outlined,
                label: "Gallery",
                color: Colors.blue,
                onTap: () => _pickImage(context, ImageSource.gallery),
              ),
              _optionButton(
                icon: Icons.camera_alt_outlined,
                label: "Camera",
                color: Colors.green,
                onTap: () => _pickImage(context, ImageSource.camera),
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
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}
