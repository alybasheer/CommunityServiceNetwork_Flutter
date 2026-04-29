import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fyp_source_code/auth/presentation/controller/auth_contrl.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:get/get.dart';

class RegisterScreenProfessional extends StatelessWidget {
  const RegisterScreenProfessional({super.key});


  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());

    return Scaffold(

      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.safetyBlue),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.l),
            child: Form(
              key: authController.registerFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSize.lHeight,
                  // HEADER
                  Text(
                    'Create Your Account',
                    style: AppTextStyling.title_30M.copyWith(
                      color: AppColors.safetyBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSize.mHeight,
                  Text(
                    'Join our community and start making a difference',
                    style: AppTextStyling.body_12S.copyWith(
                      color: AppColors.grey,
                      height: 1.5,
                    ),
                  ),
                  AppSize.xxxlHeight,

                  // FULL NAME SECTION
                  Text(
                    'Full Name',
                    style: AppTextStyling.body_12S.copyWith(
                      color: AppColors.darkGray,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSize.mHeight,
                  TextFormField(
                    controller: authController.usernameController,
                    validator: (val) => authController.validateName(val),
                    decoration: InputDecoration(
                      hintText: "Alee Basheer",
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
                        Icons.person_outline,
                        color: AppColors.steelBlue,
                      ),
                    ),
                  ),
                  AppSize.lHeight,

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
                      hintText: "ali@email.com",
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

                  // PASSWORD REQUIREMENTS INFO
                  Container(
                    padding: EdgeInsets.all(AppSize.m),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.amberOrange.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Password Requirements:',
                          style: AppTextStyling.body_12S.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGray,
                          ),
                        ),
                        AppSize.sHeight,
                        _buildRequirement('At least 6 characters'),
                        _buildRequirement(
                          'At least one uppercase letter (A-Z)',
                        ),
                        _buildRequirement(
                          'At least one lowercase letter (a-z)',
                        ),
                        _buildRequirement('At least one number (0-9)'),
                      ],
                    ),
                  ),
                  AppSize.lHeight,

                  // CONFIRM PASSWORD SECTION
                  Text(
                    'Confirm Password',
                    style: AppTextStyling.body_12S.copyWith(
                      color: AppColors.darkGray,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSize.mHeight,
                  Obx(
                    () => TextFormField(
                      controller: authController.confirmPassController,
                      obscureText:
                          !authController.isConfirmPasswordVisible.value,
                      validator:
                          (val) => authController.validateConfirmPassword(val),
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
                            authController.isConfirmPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.grey,
                          ),
                          onPressed:
                              authController.toggleConfirmPasswordVisibility,
                        ),
                      ),
                    ),
                  ),
                  AppSize.xxxlHeight,

                  // SIGNUP BUTTON
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: AppSize.buttonHeight,
                      child: ElevatedButton(
                        onPressed:
                            authController.isLoading.value
                                ? null
                                : () => authController.onRegisterClick(),
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
                                ? SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                                : Text(
                                  'Create Account',
                                  style: AppTextStyling.body_14M.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ),
                  ),
                  AppSize.xxlHeight,

                  // LOGIN LINK
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Already have an account? ',
                            style: AppTextStyling.body_12S.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                          TextSpan(
                            text: 'Sign In',
                            style: AppTextStyling.body_12S.copyWith(
                              color: AppColors.safetyBlue,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () => Get.back(),
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

  Widget _buildRequirement(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSize.s),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: AppColors.reliefGreen,
            size: 16,
          ),
          AppSize.sWidth,
          Expanded(
            child: Text(
              text,
              style: AppTextStyling.body_12S.copyWith(
                color: AppColors.darkGray,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
