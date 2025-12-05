import 'package:flutter/material.dart';
import 'package:fyp_source_code/splash_onboardings/data/models/onboarding_model.dart';
import 'package:fyp_source_code/utilities/reuse_components/storage_helper.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  late PageController pageController;
  final RxInt currentPage = 0.obs;
  final RxBool isLastPage = false.obs;

  final List<OnboardingModel> onboardingPages = [
    OnboardingModel(
      title: 'Help When You Need It',
      description:
          'Report emergencies or community tasks in real-time. Our volunteers respond instantly to help you stay safe and supported.',
      assetsImg: 'assets/icons/sosIcon.svg',
      iconColor: Color(0xFFE53935),
    ),
    OnboardingModel(
      title: 'Live Map Tracking',
      description:
          'See volunteers nearby on a live map. Track their location, get real-time updates, and connect with help faster than ever.',
      assetsImg: 'assets/icons/map.svg',
      iconColor: Color(0xFF00897B),
    ),
    OnboardingModel(
      title: 'Join Your Community',
      description:
          'Connect with volunteers in your area. Build trust, share experiences, and be part of a caring community that helps each other.',
      assetsImg: 'assets/icons/teamIcon.svg',
      iconColor: Color(0xFF0047ab),
    ),
    OnboardingModel(
      title: 'Smart Alerts',
      description:
          'Get instant notifications when volunteers respond. Never miss important updates. Stay informed, stay safe, stay connected.',
      assetsImg: 'assets/icons/alertIcon.svg',
      iconColor: Color(0xFFFB8C00),
    ),
    OnboardingModel(
      title: 'Ready to Help?',
      description:
          'Join thousands of volunteers making a difference. Whether you need help or want to help others, we\'re here for you.',
      assetsImg: 'assets/icons/thumbsup.svg',
      iconColor: Color(0xFF43A047),
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  void onPageChanged(int index) {
    currentPage.value = index;
    isLastPage.value = index == onboardingPages.length - 1;
  }

  void nextPage() {
    if (!isLastPage.value) {
      pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipOnboarding() {
    _markOnboardingAsComplete();
    Get.offAllNamed('/login');
  }

  void finishOnboarding() {
    _markOnboardingAsComplete();
    Get.offAllNamed('/login');
  }

  void _markOnboardingAsComplete() {
    StorageHelper().saveData('hasSeenOnboarding', true);
    print('✅ Onboarding marked as complete');
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
