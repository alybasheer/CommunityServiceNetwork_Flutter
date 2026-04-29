import 'package:flutter/material.dart';
import 'package:fyp_source_code/help_requests/presentation/controller/request_help_controller.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:get/get.dart';

class RequestHelpScreen extends StatelessWidget {
  RequestHelpScreen({super.key});

  final controller = Get.put(RequestHelpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        foregroundColor: AppColors.darkGray,
        title: const Text('Request Help'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSize.m),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SOSButton(controller: controller),
                AppSize.lHeight,
                Text(
                  'Help Details',
                  style: AppTextStyling.title_18M.copyWith(
                    color: AppColors.darkGray,
                  ),
                ),
                AppSize.mHeight,
                _DropdownField(
                  label: 'Category',
                  value: controller.selectedCategory,
                  items: controller.categories,
                ),
                AppSize.mHeight,
                _DropdownField(
                  label: 'Urgency',
                  value: controller.selectedUrgency,
                  items: controller.urgencies,
                ),
                AppSize.mHeight,
                TextFormField(
                  controller: controller.descriptionController,
                  validator: controller.validateDescription,
                  maxLines: 4,
                  decoration: _decoration(
                    'Description',
                    'Tell volunteers what happened',
                  ),
                ),
                AppSize.mHeight,
                TextFormField(
                  controller: controller.locationLabelController,
                  decoration: _decoration(
                    'Location note',
                    'Optional landmark or address',
                  ),
                ),
                AppSize.xlHeight,
                Obx(
                  () => ElevatedButton(
                    onPressed: controller.isSubmitting.value
                        ? null
                        : controller.submitRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.safetyBlue,
                      foregroundColor: AppColors.white,
                      minimumSize: Size(double.infinity, AppSize.buttonHeight),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      controller.isSubmitting.value
                          ? 'Submitting...'
                          : 'Submit Help Request',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: AppColors.pureWhite,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.safetyBlue, width: 2),
      ),
    );
  }
}

class _SOSButton extends StatelessWidget {
  const _SOSButton({required this.controller});

  final RequestHelpController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ElevatedButton.icon(
        onPressed:
            controller.isSubmitting.value ? null : controller.submitSOS,
        icon: const Icon(Icons.emergency_share),
        label: Text(
          controller.isSubmitting.value ? 'Sending...' : 'SOS Emergency',
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.emergencyRed,
          foregroundColor: AppColors.white,
          minimumSize: Size(double.infinity, AppSize.buttonHeight * 1.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
  });

  final String label;
  final RxString value;
  final Map<String, String> items;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DropdownButtonFormField<String>(
        value: value.value,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: AppColors.pureWhite,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        items: items.entries
            .map(
              (entry) => DropdownMenuItem(
                value: entry.key,
                child: Text(entry.value),
              ),
            )
            .toList(),
        onChanged: (selected) {
          if (selected != null) value.value = selected;
        },
      ),
    );
  }
}
