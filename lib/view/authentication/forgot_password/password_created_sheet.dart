import 'package:createex_task_application/cors/utils/bottom_sheet_service.dart';
import 'package:createex_task_application/view/authentication/sign_in/widgets/sign_in_sheet.dart';
import 'package:createex_task_application/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import '../../../cors/theme/app_colors.dart';

class PasswordCreatedSheet extends StatelessWidget {
  PasswordCreatedSheet({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.primaryWhite,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.fromLTRB(24, 50, 24, 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Transform.translate(
                  offset: const Offset(0, -30),
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B3D),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6B3D).withOpacity(0.28),
                          blurRadius: 18,
                          spreadRadius: 2,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.lock_outline,
                        color: AppColors.primaryWhite,
                        size: 34,
                      ),
                    ),
                  ),
                ),
              ),

              const Text(
                "Password Has Been Created",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1B1B1B),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "To log in to your account, click the Sign in button and \nenter your email along with your new password.",
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Color(0xFF666666),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 15),
              // Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomButton(
                  text: 'Sign In',
                  callback: () {
                    BottomSheetService.instance.dismiss(context);
                    BottomSheetService.instance.show(
                      context: context,
                      child: SignInSheet(),
                    );
                  },
                  flag: true,
                ),
              ),
            ],
          ),
        ),
        // Floating lock icon
      ],
    );
  }
}
