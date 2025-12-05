import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fyp_source_code/splash_onboardings/presentation/controller/onboarding_controller.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:get/get.dart';

class OnboardingScreenProfessional extends StatelessWidget {
  const OnboardingScreenProfessional({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  // PageView with full-screen constraint
                  PageView.builder(
                    controller: controller.pageController,
                    onPageChanged: controller.onPageChanged,
                    itemCount: controller.onboardingPages.length,
                    itemBuilder: (context, index) {
                      return _OnboardingPage(
                        model: controller.onboardingPages[index],
                        index: index,
                      );
                    },
                  ),

                  // Bottom navigation (Skip / Dots / Next)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.white,
                      child: Obx(() {
                        final isLastPage = controller.isLastPage.value;

                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 20.h,
                          ),
                          child: Row(
                            children: [
                              // SKIP BUTTON
                              TextButton(
                                onPressed: controller.skipOnboarding,
                                child: Text(
                                  'Skip',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              // DOT INDICATORS (Flexible to prevent overflow)
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    controller.onboardingPages.length,
                                    (index) => Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 2.w,
                                      ),
                                      child: Obx(() {
                                        final isActive =
                                            controller.currentPage.value ==
                                            index;
                                        return AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          width: isActive ? 16.w : 8.w,
                                          height: 8.h,
                                          decoration: BoxDecoration(
                                            color:
                                                isActive
                                                    ? const Color(0xFF6BCB77)
                                                    : Colors.grey[300],
                                            borderRadius: BorderRadius.circular(
                                              4.r,
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                              ),

                              // NEXT / DONE BUTTON
                              TextButton(
                                onPressed:
                                    isLastPage
                                        ? controller.finishOnboarding
                                        : controller.nextPage,
                                child: Text(
                                  isLastPage ? 'Done' : 'Next',
                                  style: TextStyle(
                                    color: const Color(0xFF6BCB77),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final dynamic model;
  final int index;

  const _OnboardingPage({required this.model, required this.index});

  @override
  Widget build(BuildContext context) {
    final iconSize = 110.w;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        AppSize.xxlHeight, // Top spacing
        // Animated Icon
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.3 + value * 0.7,
              child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
            );
          },
          child: Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: model.iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                model.assetsImg,
                width: 60.w,
                height: 60.h,
              ),
            ),
          ),
        ),

        AppSize.xxxlHeight, // Spacing between icon and text
        // Animated Title
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, (1 - value) * 30),
                child: Opacity(opacity: value, child: child),
              );
            },
            child: Text(
              model.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D3436),
              ),
            ),
          ),
        ),

        SizedBox(height: 15.h),

        // Animated Description
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, (1 - value) * 30),
                child: Opacity(opacity: value, child: child),
              );
            },
            child: Text(
              model.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.grey[600],
                height: 1.4,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),

        const Spacer(),

        // Decorative Shape
        Opacity(
          opacity: index % 2 == 0 ? 0.15 : 0.10,
          child: Container(
            width: index % 2 == 0 ? 240.w : 160.w,
            height: index % 2 == 0 ? 80.h : 160.w,
            decoration: BoxDecoration(
              color: model.iconColor,
              shape: index % 2 == 0 ? BoxShape.rectangle : BoxShape.circle,
              borderRadius: index % 2 == 0 ? BorderRadius.circular(40.r) : null,
            ),
          ),
        ),

        SizedBox(height: 100.h), // Space for bottom nav
      ],
    );
  }
}
