import 'package:flutter/material.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:fyp_source_code/volunteer_side/home/presentation/view/widgets/help_toggle.dart';
import 'package:fyp_source_code/volunteer_side/home/presentation/view/widgets/stat_card.dart';
import 'package:get/get.dart';

Widget sliverAppBar({
  required int completedCount,
  required double rating,
  required String fullName,
  required String locationName,
}) {
  final theme = Get.theme;
  final scheme = theme.colorScheme;
  final isDark = theme.brightness == Brightness.dark;

  return SliverToBoxAdapter(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.steelBlue.withValues(alpha: 0.88),
            AppColors.safetyBlue.withValues(alpha: 0.92),
          ],
        ),
        boxShadow: [
          // Primary shadow for depth
          BoxShadow(
            color: AppColors.safetyBlue.withValues(alpha: 0.25),
            blurRadius: 20,
            spreadRadius: 1,
            offset: Offset(0, 8),
          ),
          // Subtle inner shadow for sophistication
          BoxShadow(
            color: AppColors.steelBlue.withValues(alpha: 0.1),
            blurRadius: 12,
            spreadRadius: 0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(AppSize.m),
      child: Column(
        children: [
          // User Profile Card - Professional with Elevation
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  scheme.surface,
                  scheme.surface.withValues(alpha: isDark ? 0.92 : 0.95),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                // Outer shadow for depth
                BoxShadow(
                  color: AppColors.safetyBlue.withValues(alpha: 0.15),
                  blurRadius: 24,
                  spreadRadius: 2,
                  offset: Offset(0, 8),
                ),
                // Inner highlight for glass effect
                BoxShadow(
                  color:
                      isDark
                          ? Colors.black.withValues(alpha: 0.12)
                          : AppColors.pureWhite.withValues(alpha: 0.8),
                  blurRadius: 8,
                  spreadRadius: -2,
                  offset: Offset(0, -2),
                ),
              ],
              border: Border.all(
                color: AppColors.steelBlue.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            padding: EdgeInsets.all(AppSize.l),
            child: Row(
              children: [
                // Avatar with magical glow
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.steelBlue, AppColors.safetyBlue],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.steelBlue.withValues(alpha: 0.4),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(3),
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.steelBlue.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.person_2_rounded,
                      color: AppColors.pureWhite,
                      size: 40,
                    ),
                  ),
                ),
                SizedBox(width: AppSize.l),
                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        style: AppTextStyling.title_18M.copyWith(
                          color: scheme.onSurface,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(height: AppSize.xsH),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 16,
                            color: AppColors.steelBlue,
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              locationName.trim().isEmpty
                                  ? 'Finding nearby area...'
                                  : locationName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyling.body_12S.copyWith(
                                color: scheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Notification Badge - Elevated with rounded corners
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(
                      colors: [AppColors.emergencyRed, AppColors.amberOrange],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.emergencyRed.withValues(alpha: 0.4),
                        blurRadius: 16,
                        spreadRadius: 2,
                        offset: Offset(0, 6),
                      ),
                      BoxShadow(
                        color: AppColors.emergencyRed.withValues(alpha: 0.2),
                        blurRadius: 8,
                        spreadRadius: -1,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.notifications_rounded,
                    color: AppColors.pureWhite,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSize.mH),
          const HelpToggle(),
          SizedBox(height: AppSize.lH),
          // Stats Row
          Row(
            children: [
              Expanded(
                child: statCard(
                  completedCount.toString(),
                  'Completed',
                  Icons.check_circle_rounded,
                  AppColors.reliefGreen,
                ),
              ),
              SizedBox(width: AppSize.m),
              Expanded(
                child: statCard(
                  rating.toStringAsFixed(1),
                  'Rating',
                  Icons.star_rounded,
                  AppColors.amberOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
