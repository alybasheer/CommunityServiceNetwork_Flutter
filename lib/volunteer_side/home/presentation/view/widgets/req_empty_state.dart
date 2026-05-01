import 'package:flutter/material.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';

class ReqEmptyState extends StatelessWidget {
  const ReqEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.m),
      child: Container(
        padding: EdgeInsets.all(AppSize.m),
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.lightBorderGray),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.steelBlue, size: 22),
            SizedBox(width: AppSize.s),
            Expanded(
              child: Text(
                'No nearby requests yet. Check back in a moment.',
                style: AppTextStyling.body_14M.copyWith(
                  color: AppColors.darkGray,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
