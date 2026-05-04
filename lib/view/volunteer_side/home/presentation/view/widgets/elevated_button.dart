import 'package:flutter/material.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';

ElevatedButton elevatedButton(
  IconData iconUsed,
  String label, {
  VoidCallback? onPressed,
}) {
  return ElevatedButton(
    onPressed: onPressed ?? () {},
    style: ElevatedButton.styleFrom(
      fixedSize: Size(AppSize.sectionMedium, AppSize.xxl),
      backgroundColor: AppColors.pureWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(iconUsed, color: AppColors.safetyBlue),
        AppSize.sWidth,
        Flexible(
          child: Text(
            label,
            style: AppTextStyling.body_12S.copyWith(
              color: AppColors.safetyBlue,
            ),
          ),
        ),
      ],
    ),
  );
}
