import 'package:fyp_source_code/network/api_service.dart';
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

  /// Check token and user verification status, then navigate accordingly
  Future<void> _checkUserStatusAndNavigate() async {
    try {
      // Simulate a short delay for splash screen visibility (1.5 seconds)
      await Future.delayed(Duration(milliseconds: 1500));

      // Check if user has seen onboarding (safely handle the value)
      try {
        final onboardingData = StorageHelper().readData('hasSeenOnboarding');
        bool hasSeenOnboarding = false;

        if (onboardingData is bool) {
          hasSeenOnboarding = onboardingData as bool;
        } else if (onboardingData is String) {
          hasSeenOnboarding = onboardingData.toLowerCase() == 'true';
        }

        // First-time user - show onboarding
        if (!hasSeenOnboarding) {
          print('🎬 New user - Showing onboarding');
          Get.offAllNamed('/onboarding');
          return;
        }
      } catch (e) {
        print('⚠️ Error checking onboarding: $e - Continuing...');
      }

      // Get token from storage
      final token = StorageHelper().readData('token');

      print('🔍 Checking user status...');
      print('Token: ${token != null ? '✅ Present' : '❌ Not found'}');

      // No token means user is not logged in
      if (token == null || token.isEmpty) {
        print('❌ No token found - Navigating to login');
        userStatus.value = UserStatus.notAuthenticated;
        Get.offAllNamed('/login');
        return;
      }

      // Get user role from storage
      final role = StorageHelper().readData('role');
      print('Role: $role');

      // Admin users go to admin panel
      if (role != null && role.toString().toLowerCase() == 'admin') {
        print('👨‍💼 Admin user - Navigating to admin panel');
        Get.offAllNamed('/adminPanel');
        return;
      }

      // For volunteers: Check and navigate based on verification status
      print('📡 Checking volunteer verification status...');
      await _fetchAndNavigateBasedOnStatus();
    } catch (e) {
      print('❌ Error checking user status: $e');
      print('📊 Stack trace: $e');
      // On error, try to use cached status instead of going to login
      try {
        final cachedStatus =
            StorageHelper().readData('verificationStatus')?.toString() ?? '';
        if (cachedStatus.isNotEmpty) {
          print('📖 Using cached status after error: $cachedStatus');
          _navigateBasedOnStatus(cachedStatus);
          return;
        }
      } catch (e2) {
        print('⚠️ Could not use cached status: $e2');
      }
      // Only go to login if all else fails
      userStatus.value = UserStatus.notAuthenticated;
      Get.offAllNamed('/login');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch verification status from backend, cache it, then navigate
  Future<void> _fetchAndNavigateBasedOnStatus() async {
    try {
      // 1. Try to fetch fresh status from backend
      print('🌐 Fetching from backend: /volunteer/status');
      final response = await DioHelper().get(
        url: ApiNames.volunteerStatus,
        isauthorize: true,
      );

      print('✅ Backend response received: $response');

      // Parse verification status from response
      String verificationStatus = '';

      if (response is Map<String, dynamic>) {
        // Try multiple possible field names from backend
        verificationStatus =
            response['verificationStatus'] ??
            response['verification_status'] ??
            response['status'] ??
            response['verifyStatus'] ??
            '';
      }

      print('🔍 Parsed status: "$verificationStatus"');

      // 2. Save to local storage for offline use next time
      if (verificationStatus.isNotEmpty) {
        StorageHelper().saveData('verificationStatus', verificationStatus);
        print('💾 Status cached to local storage');
      }

      // 3. Navigate based on status
      _navigateBasedOnStatus(verificationStatus);
    } catch (e) {
      print('❌ Backend fetch failed: $e');
      print('📖 Falling back to cached status from local storage...');

      // Fallback: Use cached status from local storage
      final cachedStatus =
          StorageHelper().readData('verificationStatus')?.toString() ?? '';
      print('📦 Cached status: "$cachedStatus"');

      _navigateBasedOnStatus(cachedStatus);
    }
  }

  /// Navigate based on verification status
  void _navigateBasedOnStatus(String verificationStatus) {
    if (verificationStatus.isEmpty) {
      // First time volunteer or status not set
      print('🆕 No status - Navigating to role selection');
      userStatus.value = UserStatus.authenticated;
      Get.offAllNamed('/roleSelection');
    } else if (verificationStatus.toLowerCase() == 'pending') {
      // Pending verification - waiting for admin approval
      print('⏳ Status: pending - Navigating to waiting screen');
      userStatus.value = UserStatus.pending;
      Get.offAllNamed('/waitingScreen');
    } else if (verificationStatus.toLowerCase() == 'verified' ||
        verificationStatus.toLowerCase() == 'approved') {
      // Already verified - go straight to home
      print('✅ Status: verified/approved - Navigating to startPoint');
      userStatus.value = UserStatus.verified;
      Get.offAllNamed('/startPoint');
    } else if (verificationStatus.toLowerCase() == 'rejected' ||
        verificationStatus.toLowerCase() == 'disapproved') {
      // Rejected - go back to role selection to retry
      print('❌ Status: rejected - Navigating to role selection');
      userStatus.value = UserStatus.authenticated;
      Get.offAllNamed('/roleSelection');
    } else {
      // Unknown status - treat as regular user
      print('❓ Unknown status "$verificationStatus" - Going to home');
      userStatus.value = UserStatus.authenticated;
      Get.offAllNamed('/startPoint');
    }
  }
}
