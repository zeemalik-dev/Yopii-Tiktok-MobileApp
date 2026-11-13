// ignore_for_file: must_be_immutable

import 'package:createex_task_application/cors/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;
  final bool flag;
  final bool isLoading;
  final Color loadingColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.callback,
    required this.flag,
    this.isLoading = false,
    this.loadingColor = AppColors.primaryOrange, // default loading color
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : callback, // Disable when loading
      style: ElevatedButton.styleFrom(
        backgroundColor:
            flag ? AppColors.primaryOrange : AppColors.primaryWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: !flag
              ? const BorderSide(color: AppColors.primaryOrange, width: 1)
              : BorderSide.none,
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: isLoading
          ? CircularProgressIndicator(
              color: loadingColor,
              strokeWidth: 2.5,
            )
          : Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: flag ? AppColors.primaryWhite : AppColors.primaryOrange,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
}
