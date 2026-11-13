import 'package:createex_task_application/cors/theme/app_colors.dart';
import 'package:createex_task_application/view/authentication/sign_in/widgets/sign_in_sheet.dart';
import 'package:createex_task_application/view/authentication/sign_up/widgets/sign_up_sheet.dart';
import 'package:createex_task_application/widgets/image_box.dart';
import 'package:flutter/material.dart';
import '../../cors/utils/bottom_sheet_service.dart';
import '../../widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    height: size.height * 0.42,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.topRight,
                        colors: [
                          AppColors.primaryYellow.withOpacity(0.7),
                          AppColors.primaryOrange.withOpacity(0.9),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 40.0, left: 25, right: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ImageBox(
                            width: size.width * .4,
                            height: 250,
                            imagePath: 'assets/images/sample_image1.png',
                          ),
                          ImageBox(
                            width: size.width * .4,
                            height: 250,
                            imagePath: 'assets/images/sample_image2.png',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -80,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 250,
                        height: 167,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image:
                                AssetImage('assets/images/sample_image3.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 120), // ✅ Replaces Spacer()
              onBoarding(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget onBoarding(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            "Get the Most Out of Social\nE-commerce!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 35.0),
          child: Text(
            "Complete your profile to unlock exclusive features and enhance your experience!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.4,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomButton(
                  text: 'Sign In',
                  callback: () => BottomSheetService.instance.show(
                    context: context,
                    child: const SignInSheet(),
                  ),
                  flag: true,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomButton(
                  text: 'Sign Up',
                  callback: () => BottomSheetService.instance.show(
                    context: context,
                    child: SignUpSheet(),
                  ),
                  // showBottomSheet(
                  //     context: context,
                  //     builder: (BuildContext context) {
                  //       return const SignUpSheet();
                  //     }),
                  flag: false,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
