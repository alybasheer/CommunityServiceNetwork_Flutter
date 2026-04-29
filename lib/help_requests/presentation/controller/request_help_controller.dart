import 'package:flutter/material.dart';
import 'package:fyp_source_code/help_requests/data/models/help_request_model.dart';
import 'package:fyp_source_code/help_requests/data/repo/help_request_repo.dart';
import 'package:fyp_source_code/routing/route_names.dart';
import 'package:fyp_source_code/services/location_services.dart';
import 'package:get/get.dart';

class RequestHelpController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();
  final locationLabelController = TextEditingController();
  final repo = HelpRequestRepo();

  final selectedCategory = 'medical'.obs;
  final selectedUrgency = 'medium'.obs;
  final isSubmitting = false.obs;

  final categories = const {
    'medical': 'Medical',
    'disaster': 'Disaster',
    'blood_donation': 'Blood Donation',
    'roadblock': 'Road Block',
    'food': 'Food',
    'rescue': 'Rescue',
    'lost_found': 'Lost / Found',
    'other': 'Other',
  };

  final urgencies = const {
    'low': 'Low',
    'medium': 'Medium',
    'high': 'High',
    'critical': 'Critical',
  };

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description is required';
    }
    if (value.trim().length < 10) {
      return 'Please add a little more detail';
    }
    return null;
  }

  Future<void> submitRequest() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    await _submit(
      category: selectedCategory.value,
      description: descriptionController.text.trim(),
      urgency: selectedUrgency.value,
      isSOS: false,
      successMessage: 'Help request submitted',
    );
  }

  Future<void> submitSOS() async {
    await _submit(
      category: 'rescue',
      description: 'SOS emergency assistance needed',
      urgency: 'critical',
      isSOS: true,
      successMessage: 'SOS alert sent',
    );
  }

  Future<void> _submit({
    required String category,
    required String description,
    required String urgency,
    required bool isSOS,
    required String successMessage,
  }) async {
    if (isSubmitting.value) return;

    try {
      isSubmitting.value = true;
      final position = await getCurrentLocation();
      await repo.create(
        HelpRequestModel(
          category: category,
          description: description,
          urgency: urgency,
          latitude: position.latitude,
          longitude: position.longitude,
          locationLabel: locationLabelController.text.trim().isEmpty
              ? null
              : locationLabelController.text.trim(),
          isSOS: isSOS,
        ),
      );
      Get.snackbar('Success', successMessage);
      descriptionController.clear();
      locationLabelController.clear();
      selectedCategory.value = 'medical';
      selectedUrgency.value = 'medium';
      Get.offNamed(RouteNames.home);
    } catch (e) {
      Get.snackbar('Request failed', e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    descriptionController.dispose();
    locationLabelController.dispose();
    super.onClose();
  }
}
