import 'package:fyp_source_code/view/auth/presentation/controller/auth_contrl.dart';
import 'package:fyp_source_code/view/auth/presentation/controller/role_selection_controller.dart';
import 'package:fyp_source_code/view/volunteer_side/volunteer_verification/presentation/controller/waiting_screen_controller.dart';

import 'package:get/get.dart';

class AuthBindings extends Bindings {

  
  @override
  void dependencies() {
    Get.lazyPut <AuthController>(() => AuthController());
    Get.lazyPut <RoleSelectionController>(() => RoleSelectionController());
    Get.lazyPut <WaitingScreenController>(() => WaitingScreenController());
  }
  

  

}