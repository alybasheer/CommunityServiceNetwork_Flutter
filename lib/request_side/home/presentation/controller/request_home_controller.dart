import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:fyp_source_code/request_side/help/presentation/controller/request_help_controller.dart';
import 'package:fyp_source_code/request_side/help/presentation/view/request_help_sheet.dart';

class RequestHomeController extends GetxController {
  Future<void> openRequestHelpSheet() async {
    if (!Get.isRegistered<RequestHelpController>()) {
      Get.put(RequestHelpController());
    }

    await Get.bottomSheet(
      const RequestHelpSheet(),
      isScrollControlled: true,
      barrierColor: const Color(0x99000000),
    );

    if (Get.isRegistered<RequestHelpController>()) {
      Get.delete<RequestHelpController>();
    }
  }
}
