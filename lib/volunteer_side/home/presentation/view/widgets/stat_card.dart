import 'package:flutter/material.dart';
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
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      border: Border.all(color: color.withValues(alpha: 0.1), width: 1),
    ),
    padding: EdgeInsets.symmetric(vertical: AppSize.sH, horizontal: AppSize.s),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.14),
          ),
          padding: EdgeInsets.all(8),
          child: Icon(icon, color: color, size: 19),
        ),
        SizedBox(width: AppSize.s),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: AppTextStyling.title_18M.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              style: AppTextStyling.body_12S.copyWith(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
