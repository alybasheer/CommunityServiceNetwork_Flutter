import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_source_code/request_side/help/presentation/services/request_ai_helper.dart';

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

  void submitRequest() {
    final description = descriptionController.text.trim();
    if (description.isEmpty) {
      Get.snackbar(
        'Missing info',
        'Please describe your situation.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isSubmitting.value = true;
    Future.delayed(const Duration(milliseconds: 400), () {
      isSubmitting.value = false;
      Get.back();
      Get.snackbar(
        'Request sent',
        'We will connect you with helpers soon.',
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }
}
