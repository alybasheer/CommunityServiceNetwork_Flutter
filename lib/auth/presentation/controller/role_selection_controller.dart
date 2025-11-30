import 'package:fyp_source_code/auth/presentation/view/admin_verification_screen.dart';
import 'package:fyp_source_code/volunteer_side/home/presentation/view/home_screen.dart';
import 'package:get/get.dart';

class RoleSelectionController extends GetxController {
  final selectedRole = Rx<String?>(null);

  void selectRole(String role) {
    selectedRole.value = role;
  }

  void navigateBasedOnRole() {
    switch (selectedRole.value) {
      case 'request_help':
        // Navigate to request help flow
        // Get.toNamed('/requestHelp');
        Get.to(HomeScreen());
        break;
      case 'volunteer':
        // Navigate to volunteer onboarding or main app
        // Get.toNamed('/adminVerification');
        Get.to(AdminVerificationScreen());
        break;
      case 'admin':
        // Navigate to admin verification form
        Get.toNamed('/adminPanel');
        break;
    }
  }
}
