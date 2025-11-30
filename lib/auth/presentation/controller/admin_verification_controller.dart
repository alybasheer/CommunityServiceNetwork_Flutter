import 'package:flutter/material.dart';
import 'package:fyp_source_code/auth/data/models/admin_verification_request.dart';
import 'package:fyp_source_code/auth/data/repo/volunteer_verification_repo.dart';
import 'package:fyp_source_code/utilities/reuse_components/storage_helper.dart';
import 'package:get/get.dart';

class AdminVerificationController extends GetxController {
  final fullNameController = TextEditingController();
  final expertiseController = TextEditingController();
  final cnicController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final cityController = TextEditingController();
  final Rx<String?> selectedImagePath = Rx<String?>(null);
  final RxBool isSubmitting = false.obs;
  final RxList<VolunteerVerification> submissions = RxList();

  final VolunteerVerificationRepo _repo = VolunteerVerificationRepo();

  @override
  void onInit() {
    super.onInit();
    loadSubmissions();
  }

  /// Update status of a submission (pending -> approved/disapproved)
  void updateSubmissionStatus(String id, String newStatus) {
    final idx = submissions.indexWhere((s) => s.sId == id);
    if (idx >= 0) {
      // Update status in-place on the model
      final current = submissions[idx];
      current.status = newStatus;
      // Trigger RxList change by reassigning the item
      submissions[idx] = current;
    }
  }

  void setImagePath(String path) {
    selectedImagePath.value = path;
  }

  Future<void> submitVerification() async {
    // if (!validateForm()) {
    //   Get.snackbar('Error', 'Please fill all fields');
    //   return;
    // }

    isSubmitting.value = true;
    StorageHelper().readData('token');

    try {
      final reqBody = {
        'name': fullNameController.text,
        'expertise': expertiseController.text,
        'cnic': cnicController.text,
        'reason': descriptionController.text,
        'location': locationController.text,
        'city': cityController.text,
        // include image path if available; backend may expect multipart for actual file
        'imagePath': selectedImagePath.value,
      };

      final created = await _repo.submit(reqBody);
      

      Get.snackbar('Success', 'Your verification request has been submitted');
      clearForm();
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit: ${e.toString()}');
    } finally {
      isSubmitting.value = false;
    }
  }

  bool validateForm() {
    return fullNameController.text.isNotEmpty &&
        expertiseController.text.isNotEmpty &&
        cnicController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        locationController.text.isNotEmpty &&
        selectedImagePath.value != null;
  }

  void clearForm() {
    fullNameController.clear();
    expertiseController.clear();
    cnicController.clear();
    descriptionController.clear();
    locationController.clear();
    selectedImagePath.value = null;
  }

  Future<void> saveSubmissions() async {
    // TODO: Integrate with backend/database
    // For now, this is stored in memory
  }

  void loadSubmissions() {
    // Attempt to load from backend
    _repo
        .fetchAll()
        .then((list) {
          submissions.assignAll(list);
        })
        .catchError((e) {
          // If backend fails, keep any local data (or empty)
          print('Failed to load verifications: $e');
        });
  }

  @override
  void onClose() {
    fullNameController.dispose();
    expertiseController.dispose();
    cnicController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.onClose();
  }
}
