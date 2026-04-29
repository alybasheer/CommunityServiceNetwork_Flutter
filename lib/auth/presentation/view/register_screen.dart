import 'package:flutter/material.dart';
import 'package:fyp_source_code/auth/presentation/controller/auth_contrl.dart';
import 'package:fyp_source_code/auth/presentation/view/widgets/text_fields.dart';
import 'package:fyp_source_code/routing/route_names.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:fyp_source_code/utilities/reuse_widgets/plan_button.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSize.xl),
          child: Form(
            key: authController.registerFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSize.xxxlHeight,
                Text('Create an\nAccount!', style: AppTextStyling.title_30M),
                AppSize.xlHeight,
                Text(
                  'Full Name',
                  style: AppTextStyling.body_12S,
                  selectionColor: AppColors.grey,
                ),
                AppSize.sHeight,
                getTextField(
                  validator: (val) => authController.validateName(val),
                  hintText: "Enter Full Name",
                  controller: authController.usernameController,
                ),
                AppSize.mHeight,
                Obx(
                  () =>
                      authController.nameError.value.isNotEmpty
                          ? Padding(
                            padding: EdgeInsets.only(top: AppSize.xs),
                            child: Text(
                              authController.nameError.value,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          )
                          : SizedBox.shrink(),
                ),
                Text(
                  'Email',
                  style: AppTextStyling.body_12S,
                  selectionColor: AppColors.grey,
                ),
                AppSize.sHeight,
                getTextField(
                  validator: (val) => authController.validateEmail(val),
                  hintText: "Email",
                  controller: authController.emailController,
                ),
                AppSize.mHeight,
                Obx(
                  () =>
                      authController.emailError.value.isNotEmpty
                          ? Padding(
                            padding: EdgeInsets.only(top: AppSize.xs),
                            child: Text(
                              authController.emailError.value,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          )
                          : SizedBox.shrink(),
                ),
                Text(
                  'Password',
                  style: AppTextStyling.body_12S,
                  selectionColor: AppColors.grey,
                ),
                AppSize.sHeight,
                getPasswordTextField(authController),
                AppSize.mHeight,
                Obx(
                  () =>
                      authController.passwordError.value.isNotEmpty
                          ? Padding(
                            padding: EdgeInsets.only(top: AppSize.xs),
                            child: Text(
                              authController.passwordError.value,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          )
                          : SizedBox.shrink(),
                ),

                AppSize.xxxlHeight,
                Obx(
                  () => GestureDetector(
                    onTap: () => authController.onRegisterClick(),
                   
                    child: buildPlanButton(
                      label: 'Create Acount',
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
                AppSize.xxxlHeight,
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: AppTextStyling.body_12S.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.offNamed(RouteNames.login),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: AppSize.xs),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Login',
                        style: AppTextStyling.body_12S.copyWith(
                          color: AppColors.safetyBlue,
                          fontWeight: FontWeight.w600,
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
    );
  }
}
