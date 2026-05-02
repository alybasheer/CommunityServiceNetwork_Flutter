import 'package:fyp_source_code/routing/route_names.dart';
import 'package:fyp_source_code/utilities/reuse_components/storage_helper.dart';
import 'package:fyp_source_code/volunteer_side/volunteer_verification/presentation/view/admin_verification_screen.dart';
import 'package:get/get.dart';

class RoleSelectionController extends GetxController {
  final selectedRole = Rx<String?>(null);

  void selectRole(String role) {
    selectedRole.value = role;
    StorageHelper().saveData('selectedWorkspace', role);
  }

  void navigateBasedOnRole() {
    switch (selectedRole.value) {
      case 'request_help':
        Get.toNamed(RouteNames.requestHome);
        break;
      case 'volunteer':
        Get.to(VolunteerVerficationScreen());
        break;
    }
  }
}
