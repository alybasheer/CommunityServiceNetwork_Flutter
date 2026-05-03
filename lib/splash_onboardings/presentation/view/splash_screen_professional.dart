import 'package:flutter/material.dart';
import 'package:fyp_source_code/splash_onboardings/presentation/controller/splash_controller.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:get/get.dart';

class SplashScreenProfessional extends StatelessWidget {
  const SplashScreenProfessional({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());

    return Scaffold(
      backgroundColor: AppColors.safetyBlue,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 1100),
                      curve: Curves.easeOutBack,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: 0.72 + (value * 0.28),
                          child: Opacity(
                            opacity: value,
                            child: Container(
                              height: 132,
                              width: 132,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.18),
                                    blurRadius: 24,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/logo.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    AppSize.xxxlHeight,

                    // APP NAME
                    Text(
                      'WeHelp',
                      style: AppTextStyling.title_30M.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0,
                      ),
                    ),
                    AppSize.mHeight,

                    // TAGLINE
                    Text(
                      'Community Helping Community',
                      style: AppTextStyling.body_14M.copyWith(
                        color: Colors.white.withOpacity(0.8),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // LOADING INDICATOR WITH STATUS MESSAGE
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.l),
              child: Column(
                children: [
                  // ANIMATED PROGRESS INDICATOR
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: Duration(milliseconds: 1500),
                    builder: (context, value, child) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: value,
                          minHeight: 6,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                  AppSize.lHeight,

                  // STATUS MESSAGE
                  Obx(
                    () => Text(
                      _getStatusMessage(controller.userStatus.value),
                      style: AppTextStyling.body_12S.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  AppSize.xxxlHeight,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Get status message based on user status
  String _getStatusMessage(UserStatus status) {
    switch (status) {
      case UserStatus.notAuthenticated:
        return 'Welcome To CERD...';
      case UserStatus.authenticated:
        return 'Welcome back! Loading your profile...';
      case UserStatus.pending:
        return 'Checking your verification status...';
      case UserStatus.verified:
        return 'All set! Loading home screen...';
    }
  }
}
