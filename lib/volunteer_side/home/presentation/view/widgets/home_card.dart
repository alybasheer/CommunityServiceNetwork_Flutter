import 'package:flutter/material.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';

Column HomeCard() {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.only(
          top: AppSize.xlH,
          left: AppSize.m,
          right: AppSize.m,
          bottom: AppSize.mH,
        ),
        height: AppSize.sectionLarge,
        decoration: BoxDecoration(
          color: AppColors.safetyBlue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(backgroundColor: Colors.white, radius: AppSize.xl),

                Text(
                  'Name',
                  style: AppTextStyling.title_16M.copyWith(color: Colors.white),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: AppSize.m,
                  child: Icon(
                    Icons.notifications,
                    color: AppColors.safetyBlue,
                    size: AppSize.m,
                  ),
                ),
              ],
            ),
            AppSize.mHeight,

            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  statistics('23', 'completed'),
                  // AppSize.mWidth,
                  statistics('2.4', ' Rating'),
                  // AppSize.mWidth,
                  statistics('24', 'Available'),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Container statistics(String count, String label) {
  return Container(
    height: AppSize.sectionxs,
    // width: AppSize.sectionSmall,
    decoration: BoxDecoration(
      color: AppColors.safetyBlue.withValues(blue: .9),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Text(
            count,
            style: AppTextStyling.title_16M.copyWith(color: AppColors.white),
          ),
          Text(
            label,
            style: AppTextStyling.body_14M.copyWith(color: AppColors.white),
          ),
        ],
      ),
    ),
  );
}
