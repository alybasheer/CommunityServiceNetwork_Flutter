import 'package:flutter/material.dart';
import 'package:fyp_source_code/auth/presentation/controller/auth_contrl.dart';
import 'package:fyp_source_code/auth/presentation/view/widgets/text_fields.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:fyp_source_code/utilities/reuse_widgets/plan_button.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
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

                  Text(
                    "Login To\nYour Account",
                    style: AppTextStyling.title_30M.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  AppSize.xlHeight,
                  Text(
                    'Email Address',
                    style: AppTextStyling.body_12S.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  AppSize.mHeight,
                  getTextField(
                    validator: (val) => authController.validateEmail(val),
                    hintText: "Email",
                    controller: authController.emailController,
                  ),
                  Obx(
                    () =>
                        authController.emailError.value.isNotEmpty
                            ? Padding(
                              padding: EdgeInsets.only(top: AppSize.xs),
                              child: Text(
                                authController.emailError.value,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            )
                            : SizedBox.shrink(),
                  ),
                  AppSize.sHeight,

                  Text(
                    'Password',
                    style: AppTextStyling.body_12S.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  AppSize.mHeight,

                  getPasswordTextField(),
                  Obx(
                    () =>
                        authController.emailError.value.isNotEmpty
                            ? Padding(
                              padding: EdgeInsets.only(top: AppSize.xs),
                              child: Text(
                                authController.emailError.value,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            )
                            : SizedBox.shrink(),
                  ),

                  AppSize.lHeight,
                  Row(
                    children: [
                      Obx(
                        () => Checkbox(
                          value: authController.isRememberMe.value,
                          onChanged:
                              (value) =>
                                  authController.toggleRememberMe(value!),
                          activeColor: AppColors.safetyBlue,
                        ),
                      ),
                      Text(
                        'Remember Me',
                        style: AppTextStyling.body_12S.copyWith(
                          color: AppColors.steelBlue,
                        ),
                        selectionColor: AppColors.greyblack,
                      ),
                    ],
                  ),
                  AppSize.xxlHeight,
                  Obx(
                    () => GestureDetector(
                      onTap: () => authController.onClick(),
                      child: buildPlanButton(
                        label: 'Login',
                        backgroundColor:
                            authController.isFieldEmpt.value
                                ? AppColors.lightGrey
                                : AppColors.safetyBlue,
                        height: AppSize.xl * 2,
                        width: double.infinity,
                        textColor: AppColors.white,
                      ),
                    ),
                  ),

                  AppSize.lHeight,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Forget Password?",
                        style: AppTextStyling.body_12S.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                  AppSize.xlHeight,

                  AppSize.mHeight,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppTextStyling.body_12S.copyWith(
                          color: AppColors.grey,
                        ),
                      ),

                      TextButton(
                        onPressed: () => Get.toNamed('/register'),
                        child: Text(
                          'Create Account',
                          style: AppTextStyling.body_12S.copyWith(
                            color: AppColors.safetyBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
