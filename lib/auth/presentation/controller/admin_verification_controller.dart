import 'package:flutter/material.dart';
import 'package:fyp_source_code/auth/data/models/admin_verification_request.dart';
import 'package:get/get.dart';

class AdminVerificationController extends GetxController {
  final fullNameController = TextEditingController();
  final expertiseController = TextEditingController();
  final cnicController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();

  final Rx<String?> selectedImagePath = Rx<String?>(null);
  final RxBool isSubmitting = false.obs;
  final RxList<AdminVerificationRequest> submissions = RxList();

  @override
  void onInit() {
    super.onInit();
    loadSubmissions();
  }

  /// Update status of a submission (pending -> approved/disapproved)
  void updateSubmissionStatus(String id, String newStatus) {
    final idx = submissions.indexWhere((s) => s.id == id);
    if (idx >= 0) {
      final updated = submissions[idx].copyWith(status: newStatus);
      submissions[idx] = updated;
    }
  }

  void setImagePath(String path) {
    selectedImagePath.value = path;
  }

  Future<void> submitVerification() async {
    if (!validateForm()) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    isSubmitting.value = true;
    try {
      final request = AdminVerificationRequest(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fullName: fullNameController.text,
        expertise: expertiseController.text,
        cnicNumber: cnicController.text,
        description: descriptionController.text,
        location: locationController.text,
        imagePath: selectedImagePath.value,
        submittedAt: DateTime.now(),
        status: 'pending',
      );

      submissions.add(request);
      await saveSubmissions();

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
    // TODO: Load from backend/database
    // For now, populate some sample submissions so admin panel has data to show
    if (submissions.isEmpty) {
      submissions.addAll([
        AdminVerificationRequest(
          id: 'sample1',
          fullName: 'Ali Khan',
          expertise: 'Medical',
          cnicNumber: '35202-1234567-1',
          description: 'I have first aid & emergency response experience.',
          location: 'Downtown',
          imagePath: null,
          submittedAt: DateTime.now().subtract(Duration(hours: 5)),
          status: 'pending',
        ),
        AdminVerificationRequest(
          id: 'sample2',
          fullName: 'Sara Ahmed',
          expertise: 'Search & Rescue',
          cnicNumber: '35202-7654321-0',
          description: 'Experienced in SAR and logistics.',
          location: 'Northside',
          imagePath: null,
          submittedAt: DateTime.now().subtract(Duration(days: 1, hours: 2)),
          status: 'pending',
        ),
      ]);
    }
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
