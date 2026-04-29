import 'package:flutter/material.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';

class RequestUploadCard extends StatelessWidget {
  final VoidCallback? onTap;

  const RequestUploadCard({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.lightBorderGray,
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              color: AppColors.steelBlue,
              size: 32,
            ),
            SizedBox(height: AppSize.xsH),
            Text(
              'Upload Photo or Video',
              style: AppTextStyling.body_14M.copyWith(
                color: AppColors.darkGray,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppSize.xsH),
            Text(
              'Max 10MB',
              style: AppTextStyling.body_12S.copyWith(
                color: AppColors.mediumGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
