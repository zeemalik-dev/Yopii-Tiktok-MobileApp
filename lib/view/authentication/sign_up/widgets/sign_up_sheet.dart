import 'package:createex_task_application/controller/providers/auth_provider.dart';
import 'package:createex_task_application/cors/theme/app_colors.dart';
import 'package:createex_task_application/cors/utils/bottom_sheet_service.dart';
import 'package:createex_task_application/view/authentication/otp_authtentication/otp_authentication_sheet.dart';
import 'package:createex_task_application/view/authentication/sign_in/widgets/sign_in_sheet.dart';
import 'package:createex_task_application/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/custom_text_field.dart';

class SignUpSheet extends StatefulWidget {
  const SignUpSheet({super.key});

  @override
  State<SignUpSheet> createState() => _SignUpSheetState();
}

class _SignUpSheetState extends State<SignUpSheet> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  bool rememberMe = false;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AuthProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20, right: 30, left: 30, bottom: 30),
        child: Builder(builder: (context) {
          var provider = context.watch<AuthProvider>();
          return Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Sign Up",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Please enter the required details",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // 👇 Your form fields
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      label: 'Your Name',
                      hint: 'Enter your full name',
                      prefixIcon: Icons.person_outline,
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      label: 'User Name',
                      hint: 'Choose a username',
                      prefixIcon: Icons.account_circle_outlined,
                      controller: usernameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      label: 'Email',
                      hint: 'Enter your email address',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
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
                    const SizedBox(height: 14),
                    CustomTextField(
                      label: 'Phone Number (optional)',
                      hint: 'Enter your phone number',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      controller: phoneNumberController,
                      validator: (value) {
                        if (value != null &&
                            value.isNotEmpty &&
                            !RegExp(r'^\+?[0-9]{7,15}$').hasMatch(value)) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      label: 'Password',
                      hint: 'Enter your password',
                      prefixIcon: Icons.password,
                      controller: passwordController,
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
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
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: (value) =>
                              setState(() => rememberMe = value ?? false),
                          activeColor: const Color(0xFFFF7043),
                        ),
                        const Text("Remember Me",
                            style: TextStyle(color: Colors.black54)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: CustomButton(
                        text: "Sign Up",
                        loadingColor: AppColors.primaryOrange,
                        isLoading: provider.isLoading,
                        callback: () async {
                          if (formKey.currentState!.validate()) {
                            // Process data.
                            final result = await provider.signUp(
                              context,
                              fullName: nameController.text.trim(),
                              username: usernameController.text.trim(),
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              phoneNumber: phoneNumberController.text.trim(),
                            );

                            if (result) {
                              if (mounted) {
                                BottomSheetService.instance.dismiss(context);
                                BottomSheetService.instance.show(
                                  context: context,
                                  isDismissible: false,
                                  child: OtpAuthenticationSheet(
                                    email: emailController.text.trim(),
                                    onResend: () async {
                                      await provider.resendOtp(
                                          context, emailController.text.trim());
                                    },
                                  ),
                                );
                              }
                            }
                          }
                        },
                        flag: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              BottomSheetService.instance.dismiss(context);
                              BottomSheetService.instance
                                  .show(context: context, child: SignInSheet());
                            },
                            child: const Text(
                              "Sign in",
                              style: TextStyle(
                                color: Color(0xFFFF7043),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                // optional visual cue
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }
}
