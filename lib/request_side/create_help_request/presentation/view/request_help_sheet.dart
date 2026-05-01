import 'package:flutter/material.dart';
import 'package:fyp_source_code/request_side/create_help_request/presentation/view/widgets/request_description_field.dart';
import 'package:fyp_source_code/request_side/create_help_request/presentation/view/widgets/request_dropdown_field.dart';
import 'package:fyp_source_code/request_side/create_help_request/presentation/view/widgets/request_location_chip.dart' as request_widgets;
import 'package:fyp_source_code/request_side/create_help_request/presentation/view/widgets/request_upload_card.dart';
import 'package:get/get.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';

import '../controller/request_help_controller.dart';

class RequestHelpSheet extends StatelessWidget {
  const RequestHelpSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RequestHelpController>();

    return SafeArea(
      child: Container(
        height: AppSize.hp(86),
        padding: EdgeInsets.symmetric(horizontal: AppSize.m, vertical: AppSize.mH),
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.lightBorderGray,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              SizedBox(height: AppSize.lH),
              Text(
                'Request Help',
                style: AppTextStyling.title_18M.copyWith(
                  color: AppColors.darkGray,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: AppSize.xsH),
              Text(
                'Describe your situation and we will connect you with helpers.',
                style: AppTextStyling.body_14M.copyWith(
                  color: AppColors.mediumGray,
                ),
              ),
              SizedBox(height: AppSize.lH),
              Text(
                'Category',
                style: AppTextStyling.body_14M.copyWith(
                  color: AppColors.darkGray,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppSize.sH),
              Obx(
                () => RequestDropdownField(
                  hint: 'Select category',
                  items: controller.categories,
                  value: controller.selectedCategory.value,
                  onChanged: controller.setCategory,
                ),
              ),
              SizedBox(height: AppSize.mH),
              Text(
                'Subcategory',
                style: AppTextStyling.body_14M.copyWith(
                  color: AppColors.darkGray,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppSize.sH),
              Obx(
                () => RequestDropdownField(
                  hint: 'Select subcategory',
                  items: controller.availableSubcategories,
                  value: controller.selectedSubcategory.value,
                  onChanged: controller.setSubcategory,
                ),
              ),
              SizedBox(height: AppSize.mH),
              Text(
                'Description',
                style: AppTextStyling.body_14M.copyWith(
                  color: AppColors.darkGray,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppSize.sH),
              RequestDescriptionField(controller: controller.descriptionController),
              SizedBox(height: AppSize.sH),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: controller.applySmartSuggestion,
                  icon: const Icon(Icons.auto_fix_high, size: 18),
                  label: const Text('Improve'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.steelBlue,
                  ),
                ),
              ),
              SizedBox(height: AppSize.mH),
              RequestUploadCard(onTap: () {}),
              SizedBox(height: AppSize.mH),
              Obx(
                () => request_widgets.RequestLocationChip(
                  label: controller.locationLabel.value,
                ),
              ),
              SizedBox(height: AppSize.xlH),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.steelBlue,
                        side: BorderSide(color: AppColors.steelBlue.withValues(alpha: 0.4)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: AppSize.s),
                  Expanded(
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.isSubmitting.value
                            ? null
                            : controller.submitRequest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.steelBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          controller.isSubmitting.value ? 'Sending...' : 'Send Request',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSize.lH),
            ],
          ),
        ),
      ),
    );
  }
}
