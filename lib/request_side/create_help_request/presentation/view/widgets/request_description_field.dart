import 'package:flutter/material.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';

class RequestDescriptionField extends StatelessWidget {
  final TextEditingController controller;

  const RequestDescriptionField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.s),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightBorderGray),
      ),
      child: TextField(
        controller: controller,
        minLines: 4,
        maxLines: 6,
        style: AppTextStyling.body_14M.copyWith(
          color: AppColors.darkGray,
        ),
        decoration: InputDecoration(
          hintText: 'Describe your situation... ',
          hintStyle: AppTextStyling.body_14M.copyWith(
            color: AppColors.mediumGray,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
