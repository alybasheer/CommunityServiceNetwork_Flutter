import 'package:flutter/material.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:get/get.dart';

Widget statCard(String value, String label, IconData icon, Color color) {
  final scheme = Get.theme.colorScheme;
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [scheme.surface, scheme.surface.withValues(alpha: 0.95)],
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: color.withValues(alpha: 0.2),
          blurRadius: 16,
          spreadRadius: 0,
          offset: Offset(0, 4),
        ),
      ],
      border: Border.all(color: color.withValues(alpha: 0.1), width: 1),
    ),
    padding: EdgeInsets.symmetric(vertical: AppSize.mH, horizontal: AppSize.s),
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [color, color.withValues(alpha: 0.7)],
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          padding: EdgeInsets.all(8),
          child: Icon(icon, color: AppColors.pureWhite, size: 20),
        ),
        SizedBox(height: AppSize.s),
        Text(
          value,
          style: AppTextStyling.title_18M.copyWith(
            color: scheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: AppSize.xsH),
        Text(
          label,
          style: AppTextStyling.body_12S.copyWith(
            color: scheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
