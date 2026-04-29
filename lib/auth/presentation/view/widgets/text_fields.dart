import 'package:flutter/material.dart';
import 'package:fyp_source_code/auth/presentation/controller/auth_contrl.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:fyp_source_code/utilities/reuse_widgets/text_field.dart';
import 'package:get/get.dart';

TextEditingController textControl = TextEditingController();

Widget getTextField({
  required String hintText,
  required TextEditingController controller,
  required String? Function(String?)? validator,
}) {
  return SizedBox(
    height: AppSize.xxl * 2,
    child: CustomTextField(
      textControl: controller,
      val: validator,
      hintText: Text(
        hintText,
        style: AppTextStyling.body_12S.copyWith(color: AppColors.lightGrey),
      ),
      onChange: (value) {},
      borderType: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.steelBlue),
        borderRadius: BorderRadius.circular(8),
      ),
      fieldHeight: AppSize.l,
      focusBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: AppColors.safetyBlue, // jab focus hoga
          width: 2,
        ),
      ),
    ),
  );
}

Widget getPasswordTextField(AuthController authController) {
  return SizedBox(
    height: AppSize.xxl * 2,
    child: Obx(
      () => CustomTextField(
        hiddenText: !authController.isPasswordVisible.value,
        onChange: (value) => authController.isFieldEmpt.value = value.isEmpty,
        val: (val) => authController.validatePassword(val),

        textControl: authController.passController,
        hintText: Text(
          "Password",
          style: AppTextStyling.body_12S.copyWith(color: AppColors.lightGrey),
        ),
        borderType: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.steelBlue),
          borderRadius: BorderRadius.circular(8),
        ),
        focusBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.safetyBlue, // jab focus hoga
            width: 2,
          ),
        ),

        suffixIcon: Obx(
          () => IconButton(
            icon: Icon(
              authController.isPasswordVisible.value
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: AppColors.grey,
            ),
            onPressed:
                () =>
                    authController.isPasswordVisible.value =
                        !authController.isPasswordVisible.value,
          ),
        ),

        fieldHeight: AppSize.l,
      ),
    ),
  );
}
