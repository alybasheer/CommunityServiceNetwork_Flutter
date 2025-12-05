import 'package:fyp_source_code/auth/presentation/controller/admin_verification_controller.dart';
import 'package:fyp_source_code/network/api_service.dart';
import 'package:fyp_source_code/services/api_names.dart';
import 'package:get/get.dart';

class AdminPanelController extends GetxController {
  late final AdminVerificationController verificationCtrl;
  final dioHelper = DioHelper();
  var res = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchVolunteerApplications();

    verificationCtrl = Get.put(AdminVerificationController());
  }

  Future<dynamic> fetchVolunteerApplications() async {
    try {
      final response = await dioHelper.get(
        url: ApiNames.voulnteerApplications,
        isauthorize: true,
      );
      res.value = response['data'];
      return res;
    } catch (e) {
      print('Error fetching volunteer applications: $e');
      rethrow;
    }
  }

  Future<dynamic> approveVolunteer(String userId) {
    return dioHelper.post(
      url: ApiNames.approveVolunteer(userId),
      isauthorize: true,
    ).then((value) {
      fetchVolunteerApplications();
      res.refresh();
      Get.back();
    });
  }
  Future<dynamic> rejectVolunteer(String userId) {
    return dioHelper.post(
      url: ApiNames.rejectVolunteer(userId),
      isauthorize: true,
    ).then((value){
      fetchVolunteerApplications();
      res.refresh();
      Get.back();
    });
  }

  void approve(String id, int index) {
    verificationCtrl.updateSubmissionStatus(id, 'approved');
  }

  void disapprove(String id) {
    verificationCtrl.updateSubmissionStatus(id, 'disapproved');
  }
}
