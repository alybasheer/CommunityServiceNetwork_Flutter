import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fyp_source_code/auth/presentation/controller/auth_contrl.dart';
import 'package:fyp_source_code/utilities/helpers/toast_helper.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:fyp_source_code/utilities/reuse_widgets/shimmer_loading.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.l),
            child: Form(
              key: authController.loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSize.xxxlHeight,
                  // HEADER
                  Text(
                    "Welcome Back!",
                    style: AppTextStyling.title_30M.copyWith(
                      color: AppColors.safetyBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSize.mHeight,
                  Text(
                    "Sign in to continue helping your community",
                    style: AppTextStyling.body_12S.copyWith(
                      color: AppColors.grey,
                      height: 1.5,
                    ),
                  ),
                  AppSize.xxxlHeight,

                  // EMAIL SECTION
                  Text(
                    'Email Address',
                    style: AppTextStyling.body_12S.copyWith(
                      color: AppColors.darkGray,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSize.mHeight,
                  TextFormField(
                    controller: authController.emailController,
                    validator: (val) => authController.validateEmail(val),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "example@email.com",
                      hintStyle: AppTextStyling.body_12S.copyWith(
                        color: AppColors.lightGrey,
                      ),
                      filled: true,
                      fillColor: Color(0xFFF5F7FA),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.lightBorderGray,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.lightBorderGray,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.safetyBlue,
                          width: 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSize.m,
                        vertical: AppSize.m,
                      ),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: AppColors.steelBlue,
                      ),
                    ),
                  ),
                  AppSize.lHeight,

                  // PASSWORD SECTION
                  Text(
                    'Password',
                    style: AppTextStyling.body_12S.copyWith(
                      color: AppColors.darkGray,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSize.mHeight,
                  Obx(
                    () => TextFormField(
                      controller: authController.passController,
                      obscureText: !authController.isPasswordVisible.value,
                      validator: (val) => authController.validatePassword(val),
                      decoration: InputDecoration(
                        hintText: "••••••••",
                        hintStyle: AppTextStyling.body_12S.copyWith(
                          color: AppColors.lightGrey,
                        ),
                        filled: true,
                        fillColor: Color(0xFFF5F7FA),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.lightBorderGray,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.lightBorderGray,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.safetyBlue,
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AppSize.m,
                          vertical: AppSize.m,
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outlined,
                          color: AppColors.steelBlue,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            authController.isPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.grey,
                          ),
                          onPressed: authController.togglePasswordVisibility,
                        ),
                      ),
                    ),
                  ),
                  AppSize.lHeight,

                  // REMEMBER ME & FORGOT PASSWORD
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => GestureDetector(
                          onTap:
                              () => authController.toggleRememberMe(
                                !authController.isRememberMe.value,
                              ),
                          child: Row(
                            children: [
                              Checkbox(
                                value: authController.isRememberMe.value,
                                onChanged:
                                    (value) =>
                                        authController.toggleRememberMe(value!),
                                activeColor: AppColors.safetyBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              Text(
                                'Remember me',
                                style: AppTextStyling.body_12S.copyWith(
                                  color: AppColors.steelBlue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          ToastHelper.showInfo(
                            'Password reset feature coming soon',
                          );
                        },
                        child: Text(
                          "Forgot Password?",
                          style: AppTextStyling.body_12S.copyWith(
                            color: AppColors.emergencyRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSize.xxxlHeight,

                  // LOGIN BUTTON
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: AppSize.buttonHeight,
                      child: ElevatedButton(
                        onPressed:
                            authController.isLoading.value
                                ? null
                                : () => authController.onLogin(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.safetyBlue,
                          disabledBackgroundColor: AppColors.lightGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child:
                            authController.isLoading.value
                                ? AppShimmer(
                                  child: Container(
                                    height: 18,
                                    width: 88,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.35),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                )
                                : Text(
                                  'Sign In',
                                  style: AppTextStyling.body_14M.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ),
                  ),
                  AppSize.xxxlHeight,
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Don't have an account? ",
                            style: AppTextStyling.body_12S.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                          TextSpan(
                            text: 'Sign Up',
                            style: AppTextStyling.body_12S.copyWith(
                              color: AppColors.safetyBlue,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () => Get.toNamed('/signup'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppSize.xxxlHeight,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
