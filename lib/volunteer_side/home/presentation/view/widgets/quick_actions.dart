  import 'package:flutter/material.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:get/get.dart';



Widget quickActionsSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(AppSize.m),
        child: Row(
          children: [
            actionButton(
              icon: Icons.notifications_active,
              label: 'Alerts',
              color: AppColors.pureWhite,
              backgroundColor: AppColors.emergencyRed,
              onTap: () {},
            ),
            SizedBox(width: AppSize.m),
            actionButton(
              icon: Icons.people_alt,
              label: 'Coordination',
              color: AppColors.pureWhite,
              backgroundColor: AppColors.steelBlue,
              onTap: () => Get.toNamed('/coordination'),
            ),
          ],
        ),
      ),
    );
  }

    Widget actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(
            vertical: AppSize.mH,
            horizontal: AppSize.s,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              SizedBox(width: AppSize.s),
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppTextStyling.body_14M.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }