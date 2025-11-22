import 'package:fyp_source_code/auth/presentation/controller/admin_verification_controller.dart';
import 'package:get/get.dart';

class AdminPanelController extends GetxController {
  late final AdminVerificationController verificationCtrl;

  @override
  void onInit() {
    super.onInit();
    verificationCtrl = Get.put(AdminVerificationController());
  }

  // Expose submissions as RxList for the view
  RxList get submissions => verificationCtrl.submissions;

  void approve(String id) {
    verificationCtrl.updateSubmissionStatus(id, 'approved');
  }

  void disapprove(String id) {
    verificationCtrl.updateSubmissionStatus(id, 'disapproved');
  }
}
