import 'package:createex_task_application/controller/providers/auth_provider.dart';
import 'package:createex_task_application/view/authentication/sign_up/widgets/sign_up_sheet.dart';
import 'package:createex_task_application/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../cors/routes/app_routes.dart';
import '../../../../cors/utils/bottom_sheet_service.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../forgot_password/forgot_password_sheet.dart';

class SignInSheet extends StatefulWidget {
  const SignInSheet({super.key});

  @override
  State<SignInSheet> createState() => _SignInSheetState();
}

class _SignInSheetState extends State<SignInSheet> {
  bool rememberMe = false;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<AuthProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
        child: SingleChildScrollView(
          child: Builder(builder: (context) {
            var provider = context.watch<AuthProvider>();
            return Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Center(
                    child: Column(
                      children: [
                        Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Sign in to my account",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  CustomTextField(
                    label: 'Email',
                    hint: 'My Email',
                    prefixIcon: Icons.email_outlined,
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      // Simple email validation
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  CustomTextField(
                    label: 'Password',
                    hint: 'Enter your password',
                    prefixIcon: Icons.fingerprint_outlined,
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
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: rememberMe,
                            onChanged: (value) {
                              setState(() {
                                rememberMe = value ?? false;
                              });
                            },
                            activeColor: const Color(0xFFFF7043),
                          ),
                          const Text(
                            "Remember Me",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                              decorationColor: Colors.black87,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          BottomSheetService.instance.dismiss(context);
                          BottomSheetService.instance.show(
                            context: context,
                            child: ForgotPasswordSheet(),
                          );
                        },
                        child: const Text(
                          "Forgot Password",
                          style: TextStyle(
                            color: Color(0xFFFF7043),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 17),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: CustomButton(
                      text: 'Signin',
                      isLoading: provider.isLoading,
                      callback: () async {
                        if (formKey.currentState!.validate()) {
                          final result = await provider.login(
                            context,
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          );

                          if (result) {
                            BottomSheetService.instance.dismiss(context);
                            Get.offAllNamed(AppRoutes.home);
                          }
                        }
                      },
                      flag: true,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "I don't have any account ? ",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            BottomSheetService.instance.dismiss(context);
                            BottomSheetService.instance
                                .show(context: context, child: SignUpSheet());
                          },
                          child: const Text(
                            "Sign up",
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

                  const SizedBox(height: 15),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
