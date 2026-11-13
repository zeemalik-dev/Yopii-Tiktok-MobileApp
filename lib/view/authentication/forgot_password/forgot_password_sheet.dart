import 'package:createex_task_application/cors/utils/bottom_sheet_service.dart';
import 'package:createex_task_application/view/authentication/forgot_password/forgot_password_reset_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controller/providers/forgot_password_provider.dart';
import '../../../cors/theme/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';

class ForgotPasswordSheet extends StatefulWidget {
  const ForgotPasswordSheet({super.key});

  @override
  State<ForgotPasswordSheet> createState() => _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends State<ForgotPasswordSheet> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<ForgotProvider>();
  }

  @override
  Widget build(BuildContext context) {
    final pro = context.watch<ForgotProvider>();

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
                const Text(
                  "Forgot Password",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkBlack,
                  ),
                ),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Reset password code will be sent to your email to reset \nyour password.",
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: AppColors.darkGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  label: 'Email',
                  hint: 'Tonald@work.com',
                  prefixIcon: Icons.email_outlined,
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButton(
                    text: 'Send Verification Code',
                    isLoading: pro.isLoading,
                    callback: () async {
                      if (formKey.currentState!.validate()) {
                        final result = await pro.requestForgotPassword(
                          context,
                          emailController.text.trim(),
                        );
                        if (result) {
                          BottomSheetService.instance.dismiss(context);
                          BottomSheetService.instance.show(
                            context: context,
                            isDismissible: false,
                            child: ForgotPasswordResetSheet(
                              email: emailController.text.trim(),
                            ),
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
