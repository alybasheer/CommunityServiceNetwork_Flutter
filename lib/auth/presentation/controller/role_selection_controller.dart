import 'package:fyp_source_code/auth/presentation/view/admin_verification_screen.dart';
import 'package:fyp_source_code/routing/route_names.dart';
import 'package:fyp_source_code/utilities/reuse_components/storage_helper.dart';
import 'package:get/get.dart';

class RoleSelectionController extends GetxController {
  final selectedRole = Rx<String?>(null);

  void selectRole(String role) {
    selectedRole.value = role;
  }

  void navigateBasedOnRole() {
    final currentRole = StorageHelper().readData('role');

    switch (selectedRole.value) {
      case 'requestHelp':
        Get.toNamed(RouteNames.requestHelp);
        break;
      case 'volunteer':
        if (currentRole == 'volunteer') {
          Get.toNamed(RouteNames.startPoint);
        } else {
          Get.to(AdminVerificationScreen());
        }
        break;
      case 'admin':
        if (currentRole == 'admin') {
          Get.toNamed('/adminPanel');
        }
        break;
    }
  }
}
