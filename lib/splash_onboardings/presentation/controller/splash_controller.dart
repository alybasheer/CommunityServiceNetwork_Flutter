import 'package:fyp_source_code/network/api_service.dart';
import 'package:fyp_source_code/routing/route_names.dart';
import 'package:fyp_source_code/services/api_names.dart';
import 'package:fyp_source_code/utilities/reuse_components/storage_helper.dart';
import 'package:get/get.dart';

enum UserStatus { authenticated, pending, verified, notAuthenticated }

class SplashController extends GetxController {
  final RxBool isLoading = true.obs;
  final Rx<UserStatus> userStatus = UserStatus.notAuthenticated.obs;

  @override
  void onInit() {
    super.onInit();
    _checkUserStatusAndNavigate();
  }

  Future<void> _checkUserStatusAndNavigate() async {
    try {
      await Future.delayed(const Duration(milliseconds: 1500));

      if (!_hasSeenOnboarding()) {
        Get.offAllNamed(RouteNames.onboarding);
        return;
      }

      final token = StorageHelper().readData('token')?.toString() ?? '';
      if (token.isEmpty) {
        userStatus.value = UserStatus.notAuthenticated;
        Get.offAllNamed(RouteNames.login);
        return;
      }

      final role =
          StorageHelper().readData('role')?.toString().toLowerCase() ?? '';

      if (role == 'admin') {
        Get.offAllNamed(RouteNames.adminPanel);
        return;
      }

      if (_isRequesteeRole(role)) {
        userStatus.value = UserStatus.authenticated;
        Get.offAllNamed(RouteNames.requestHome);
        return;
      }

      await _fetchAndNavigateBasedOnStatus();
    } catch (e) {
      final cachedStatus =
          StorageHelper().readData('verificationStatus')?.toString() ?? '';
      if (cachedStatus.isNotEmpty) {
        _navigateBasedOnStatus(cachedStatus);
        return;
      }

      userStatus.value = UserStatus.notAuthenticated;
      Get.offAllNamed(RouteNames.login);
    } finally {
      isLoading.value = false;
    }
  }

  bool _hasSeenOnboarding() {
    final onboardingData = StorageHelper().readData('hasSeenOnboarding');
    if (onboardingData is bool) {
      return onboardingData;
    }
    if (onboardingData is String) {
      return onboardingData.toLowerCase() == 'true';
    }
    return false;
  }

  bool _isRequesteeRole(String role) {
    return role == 'requestee' ||
        role == 'request_help' ||
        role == 'requesthelp';
  }

  Future<void> _fetchAndNavigateBasedOnStatus() async {
    try {
      final response = await DioHelper().get(
        url: ApiNames.volunteerStatus,
        isauthorize: true,
      );

      var verificationStatus = '';
      if (response is Map<String, dynamic>) {
        verificationStatus =
            response['verificationStatus']?.toString() ??
            response['verification_status']?.toString() ??
            response['status']?.toString() ??
            response['verifyStatus']?.toString() ??
            '';
      }

      if (verificationStatus.isNotEmpty) {
        StorageHelper().saveData('verificationStatus', verificationStatus);
      }

      _navigateBasedOnStatus(verificationStatus);
    } catch (e) {
      final cachedStatus =
          StorageHelper().readData('verificationStatus')?.toString() ?? '';
      _navigateBasedOnStatus(cachedStatus);
    }
  }

  void _navigateBasedOnStatus(String verificationStatus) {
    final status = verificationStatus.toLowerCase();
    if (status.isEmpty) {
      userStatus.value = UserStatus.authenticated;
      Get.offAllNamed(RouteNames.roleSelection);
    } else if (status == 'pending') {
      userStatus.value = UserStatus.pending;
      Get.offAllNamed(RouteNames.waitingScreen);
    } else if (status == 'verified' || status == 'approved') {
      userStatus.value = UserStatus.verified;
      Get.offAllNamed(RouteNames.startPoint);
    } else if (status == 'rejected' || status == 'disapproved') {
      userStatus.value = UserStatus.authenticated;
      Get.offAllNamed(RouteNames.roleSelection);
    } else {
      userStatus.value = UserStatus.authenticated;
      Get.offAllNamed(RouteNames.startPoint);
    }
  }
}
