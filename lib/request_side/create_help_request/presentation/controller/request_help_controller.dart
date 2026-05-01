import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_source_code/request_side/create_help_request/presentation/services/request_ai_helper.dart';
import 'package:fyp_source_code/request_side/create_help_request/data/repo/help_request_repo.dart';
import 'package:fyp_source_code/services/location_services.dart';
import 'package:fyp_source_code/utilities/helpers/toast_helper.dart';

class RequestHelpController extends GetxController {
  final categories = <String>[
    'Natural Disaster',
    'Medical',
    'Accident',
    'Shelter',
    'Other',
  ];

  final Map<String, List<String>> subcategoriesByCategory = {
    'Natural Disaster': ['Flood', 'Earthquake', 'Storm', 'Landslide'],
    'Medical': ['Injury', 'Illness', 'Urgent Transport'],
    'Accident': ['Road Accident', 'Fire', 'Collapse'],
    'Shelter': ['Temporary Shelter', 'Food Supply', 'Water Supply'],
    'Other': ['General Help'],
  };

  final selectedCategory = Rx<String?>(null);
  final selectedSubcategory = Rx<String?>(null);

  final descriptionController = TextEditingController();
  final locationLabel = 'Location Auto-Detected'.obs;
  final isSubmitting = false.obs;

  final HelpRequestRepo _repo = HelpRequestRepo();

  List<String> get availableSubcategories {
    return subcategoriesByCategory[selectedCategory.value] ?? <String>[];
  }

  void setCategory(String? value) {
    selectedCategory.value = value;
    final subs = availableSubcategories;
    selectedSubcategory.value = subs.isEmpty ? null : subs.first;
  }

  void setSubcategory(String? value) {
    selectedSubcategory.value = value;
  }

  void applySmartSuggestion() {
    final suggestion = RequestAiHelper.enhanceDescription(
      descriptionController.text,
    );
    if (suggestion.isNotEmpty) {
      descriptionController.text = suggestion;
    }
  }

  Future<void> submitRequest() async {
    final description = descriptionController.text.trim();
    if (selectedCategory.value == null || selectedSubcategory.value == null) {
      ToastHelper.showError('Please select a category and subcategory.');
      return;
    }
    if (description.isEmpty) {
      ToastHelper.showError('Please describe your situation.');
      return;
    }

    isSubmitting.value = true;

    try {
      final position = await getCurrentLocation();
      final reqBody = {
        'category': selectedCategory.value,
        'subCategory': selectedSubcategory.value,
        'description': description,
        'image': null,
        'latitude': position.latitude,
        'longitude': position.longitude,
      };

      await _repo.createRequest(reqBody);
      Get.back();
      ToastHelper.showSuccess('Request sent successfully.');
    } catch (e) {
      ToastHelper.showErrorMessage(e);
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }
}
