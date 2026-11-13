import 'package:createex_task_application/cors/utils/bottom_sheet_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../../../controller/providers/auth_provider.dart';
import '../../../cors/routes/app_routes.dart';
import '../../../cors/theme/app_colors.dart';
import '../../../widgets/custom_button.dart';

class OtpAuthenticationSheet extends StatefulWidget {
  final String email;
  final VoidCallback onResend;

  const OtpAuthenticationSheet({
    super.key,
    required this.email,
    required this.onResend,
  });

  @override
  State<OtpAuthenticationSheet> createState() => _OtpAuthenticationSheetState();
}

class _OtpAuthenticationSheetState extends State<OtpAuthenticationSheet> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AuthProvider>();
  }

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Builder(builder: (context) {
      var pro = context.watch<AuthProvider>();
      return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // 🧱 Main White Card
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primaryWhite,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlack.withOpacity(0.06),
                  blurRadius: 18,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // Close Button

                    Container(
                      width: 95,
                      height: 95,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/images/2fa_image.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                const Text(
                  "Authentication",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkBlack,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "An authentication code has been sent to\n${widget.email}, check your email to continue the sign-up process.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),

                // 🔢 OTP Input
                Pinput(
                  controller: controller,
                  length: 6,
                  showCursor: true,
                  defaultPinTheme: PinTheme(
                    height: 55,
                    width: 55,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black26),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 🔁 Resend text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Haven’t received the verification code? ",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onResend, // or your resend callback
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

                const SizedBox(height: 20),

                // 🧡 Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButton(
                    text: "Submit",
                    isLoading: pro.isLoading,
                    flag: true,
                    callback: () async {
                      final result =
                          await pro.verifyOtp(context, controller.text.trim());
                      if (result) {
                        if (mounted) {
                          BottomSheetService.instance.dismiss(context);
                          Get.offAllNamed(AppRoutes.home);
                        }
                      }
                      // You can add submission logic here if needed
                    },
                  ),
                ),
              ],
            ),
          ),

          // 🔒 Floating 2FA Icon Box
        ],
      );
    });
  }
}
