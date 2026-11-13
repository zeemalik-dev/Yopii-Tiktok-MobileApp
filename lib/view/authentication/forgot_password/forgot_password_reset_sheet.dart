import 'package:createex_task_application/controller/providers/forgot_password_provider.dart';
import 'package:createex_task_application/cors/theme/app_colors.dart';
import 'package:createex_task_application/cors/utils/bottom_sheet_service.dart';
import 'package:createex_task_application/view/authentication/forgot_password/password_created_sheet.dart';
import 'package:createex_task_application/widgets/custom_button.dart';
import 'package:createex_task_application/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class ForgotPasswordResetSheet extends StatefulWidget {
  final String email;
  const ForgotPasswordResetSheet({super.key, required this.email});

  @override
  State<ForgotPasswordResetSheet> createState() =>
      _ForgotPasswordResetSheetState();
}

class _ForgotPasswordResetSheetState extends State<ForgotPasswordResetSheet> {
  final otpController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<ForgotProvider>();
  }

  @override
  Widget build(BuildContext context) {
    var pro = context.watch<ForgotProvider>();

    return Form(
      key: formKey,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primaryWhite,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlack.withOpacity(0.06),
                  blurRadius: 18,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(24, 50, 24, 36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon at the top
                Align(
                  alignment: Alignment.topCenter,
                  child: Transform.translate(
                    offset: const Offset(0, -30),
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: AppColors.darkOrage,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.darkOrage.withOpacity(0.28),
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

                const SizedBox(height: 10),

                const Text(
                  "Reset Your Password",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1B1B1B),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "A reset code has been sent to ${widget.email}, please verify the code and set a new password.",
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Color(0xFF666666),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // OTP Field
                Pinput(
                  controller: otpController,
                  length: 6,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the verification code';
                    }
                    if (value.length < 6) {
                      return 'Code must be 6 digits long';
                    }
                    return null;
                  },
                  showCursor: true,
                  defaultPinTheme: PinTheme(
                    height: 55,
                    width: 55,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black26),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Resend link
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Didn’t receive the code? ",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await pro.resendOtp(context, widget.email);
                        },
                        child: const Text(
                          "Resend it",
                          style: TextStyle(
                            color: AppColors.primaryOrange,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // New password fields
                CustomTextField(
                  label: 'New Password',
                  hint: 'Enter your password',
                  prefixIcon: Icons.password,
                  controller: passwordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your new password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  label: 'Confirm Password',
                  hint: 'Re-enter your password',
                  prefixIcon: Icons.password,
                  controller: confirmPasswordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 25),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButton(
                    text: 'Submit',
                    isLoading: pro.isLoading,
                    callback: () async {
                      if (formKey.currentState!.validate()) {
                        final otp = otpController.text.trim();
                        final pass = passwordController.text.trim();

                        final result = await pro.resetPassword(
                          context,
                          otp: otp,
                          newPassword: pass,
                        );

                        if (result && mounted) {
                          BottomSheetService.instance.dismiss(context);
                          BottomSheetService.instance.show(
                            context: context,
                            child: PasswordCreatedSheet(),
                          );
                        }
                      }
                    },
                    flag: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
