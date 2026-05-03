import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fyp_source_code/request_side/create_help_request/data/repo/help_request_repo.dart';
import 'package:fyp_source_code/request_side/create_help_request/presentation/services/request_ai_helper.dart';
import 'package:fyp_source_code/services/location_services.dart';
import 'package:fyp_source_code/utilities/helpers/toast_helper.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RequestPhoto {
  final XFile file;
  final Uint8List bytes;

  const RequestPhoto({required this.file, required this.bytes});

  String get name {
    final pathName = file.path.split(RegExp(r'[\\/]')).last.trim();
    return pathName.isNotEmpty ? pathName : file.name;
  }

  String? get mimeType => file.mimeType;

  int get sizeInBytes => bytes.length;

  String get sizeLabel {
    final mb = sizeInBytes / (1024 * 1024);
    if (mb >= 1) {
      return '${mb.toStringAsFixed(1)} MB';
    }
    return '${(sizeInBytes / 1024).toStringAsFixed(0)} KB';
  }
}

class RequestHelpController extends GetxController {
  static const int maxPhotos = 2;
  static const int maxPhotoBytes = 5 * 1024 * 1024;

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
  final locationLabel = 'Resolving nearby area...'.obs;
  final isSubmitting = false.obs;
  final selectedPhotos = <RequestPhoto>[].obs;

  final HelpRequestRepo _repo = HelpRequestRepo();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _resolveCurrentLocationLabel();
  }

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

  Future<void> pickPhotos() async {
    final remainingSlots = maxPhotos - selectedPhotos.length;
    if (remainingSlots <= 0) {
      ToastHelper.showWarning('You can attach up to 2 photos.');
      return;
    }

    try {
      final picked = await _imagePicker.pickMultiImage(imageQuality: 82);
      if (picked.isEmpty) {
        return;
      }

      var skippedForSize = 0;
      for (final file in picked.take(remainingSlots)) {
        final bytes = await file.readAsBytes();
        if (bytes.length > maxPhotoBytes) {
          skippedForSize++;
          continue;
        }
        selectedPhotos.add(RequestPhoto(file: file, bytes: bytes));
      }

      if (picked.length > remainingSlots) {
        ToastHelper.showInfo('Only 2 photos can be attached.');
      } else if (skippedForSize > 0) {
        ToastHelper.showWarning('Some photos were over 5MB and were skipped.');
      }
    } catch (e) {
      ToastHelper.showErrorMessage(e);
    }
  }

  void removePhoto(int index) {
    if (index < 0 || index >= selectedPhotos.length) {
      return;
    }
    selectedPhotos.removeAt(index);
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
      final resolvedName = await getLocationNameFromCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      final mediaUrls = await _uploadSelectedPhotos();
      final reqBody = {
        'category': selectedCategory.value,
        'subCategory': selectedSubcategory.value,
        'description': description,
        'latitude': position.latitude,
        'longitude': position.longitude,
        if (mediaUrls.isNotEmpty) 'mediaUrls': mediaUrls,
        if (mediaUrls.isNotEmpty) 'image': mediaUrls.first,
        if (resolvedName != 'Location unavailable')
          'locationName': resolvedName,
      };

      await _repo.createRequest(reqBody);
      Get.back();
      ToastHelper.showSuccess('Request sent successfully.');
      _resetForm();
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

  Future<List<String>> _uploadSelectedPhotos() async {
    if (selectedPhotos.isEmpty) {
      return <String>[];
    }

    final files =
        selectedPhotos.map((photo) {
          return RequestMediaUpload(
            filename: photo.name,
            bytes: photo.bytes,
            mimeType: photo.mimeType,
          );
        }).toList();

    final urls = await _repo.uploadRequestMedia(files);
    if (urls.length != selectedPhotos.length) {
      throw Exception('Could not upload all selected photos.');
    }

    return urls;
  }

  void _resetForm() {
    selectedCategory.value = null;
    selectedSubcategory.value = null;
    descriptionController.clear();
    selectedPhotos.clear();
  }

  Future<void> _resolveCurrentLocationLabel() async {
    try {
      final position = await getCurrentLocation();
      final resolvedName = await getLocationNameFromCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      if (resolvedName != 'Location unavailable' &&
          resolvedName.trim().isNotEmpty) {
        locationLabel.value = resolvedName;
      }
    } catch (_) {
      locationLabel.value = 'Location unavailable';
    }
  }
}
