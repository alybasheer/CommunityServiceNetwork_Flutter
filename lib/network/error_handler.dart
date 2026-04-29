import 'package:fyp_source_code/network/exceptions.dart';
import 'package:get/get.dart';

class ErrorHandler {

  static void exception(Object e) {
    if (e is Exception && e is AppExceptions) {
      final ex = e;
      Get.snackbar('Error', ex.msg);
      print("AppException: ${ex.toString()}");
    } else if (e is Exception) {
      Get.snackbar('Error', 'Something Went Wrong');
      print("Unknown Exception: $e");
    } else {
      // non-Exception errors (TypeError, Error) - surface readable message and log
      Get.snackbar('Error', 'Unexpected error occurred');
      print("Error object: $e");
    }
  }
}
