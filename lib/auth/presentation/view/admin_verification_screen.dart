import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyp_source_code/auth/presentation/controller/admin_verification_controller.dart';
import 'package:fyp_source_code/auth/presentation/view/widgets/text_fields.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:get/get.dart';

class AdminVerificationScreen extends StatelessWidget {
  const AdminVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminVerificationController());

    Future<void> pickImage() async {
      // TODO: Implement image picker with image_picker package
      Get.snackbar('Info', 'Image picker to be implemented');
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Get.back(),
        ),
        title: Text('Admin Verification', style: AppTextStyling.title_18M),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSize.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Complete Your Profile', style: AppTextStyling.title_18M),
              AppSize.sHeight,
              Text(
                'Please provide your details for admin verification',
                style: AppTextStyling.body_12S.copyWith(color: AppColors.grey),
              ),
              AppSize.lHeight,
              // Profile Image
              Text('Profile Photo', style: AppTextStyling.body_14M),
              AppSize.sHeight,
              Obx(
                () => GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(AppSize.m),
                      border: Border.all(color: AppColors.steelBlue, width: 2),
                    ),
                    child:
                        controller.selectedImagePath.value != null
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AppSize.m - 2,
                              ),
                              child: Image.file(
                                File(controller.selectedImagePath.value!),
                                fit: BoxFit.cover,
                              ),
                            )
                            : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  color: AppColors.steelBlue,
                                  size: 32,
                                ),
                                AppSize.sHeight,
                                Text(
                                  'Tap to upload photo',
                                  style: AppTextStyling.body_12S.copyWith(
                                    color: AppColors.steelBlue,
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
              ),
              AppSize.lHeight,
              // Full Name
              Text('Full Name', style: AppTextStyling.body_14M),
              AppSize.sHeight,
              getTextField(
                hintText: 'Enter your full name',
                controller: controller.fullNameController,
                validator: (val) => null,
              ),
              AppSize.mHeight,
              // Expertise
              Text('Area of Expertise', style: AppTextStyling.body_14M),
              AppSize.sHeight,
              getTextField(
                hintText: 'e.g., Medical, Search & Rescue, Logistics',
                controller: controller.expertiseController,
                validator: (val) => null,
              ),
              AppSize.mHeight,
              // CNIC Number
              Text('CNIC Number', style: AppTextStyling.body_14M),
              AppSize.sHeight,
              getTextField(
                hintText: 'Enter your CNIC number',
                controller: controller.cnicController,
                validator: (val) => null,
              ),
              AppSize.mHeight,
              // Description
              Text(
                'Why do you want to volunteer?',
                style: AppTextStyling.body_14M,
              ),
              AppSize.sHeight,
              TextField(
                controller: controller.descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Tell us why you want to volunteer...',
                  hintStyle: AppTextStyling.body_12S.copyWith(
                    color: AppColors.lightGrey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSize.m),
                    borderSide: BorderSide(color: AppColors.lightBorderGray),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSize.m),
                    borderSide: BorderSide(color: AppColors.lightBorderGray),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSize.m),
                    borderSide: BorderSide(
                      color: AppColors.safetyBlue,
                      width: 2,
                    ),
                  ),
                  contentPadding: EdgeInsets.all(AppSize.m),
                  filled: true,
                  fillColor: AppColors.background,
                ),
                style: AppTextStyling.body_12S,
              ),
              AppSize.mHeight,
              // Location
              Text('Location', style: AppTextStyling.body_14M),
              AppSize.sHeight,
              getTextField(
                hintText: 'Enter your location',
                controller: controller.locationController,
                validator: (val) => null,
              ),
              AppSize.xxxlHeight,
              // Submit Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: AppSize.hp(6),
                  child: ElevatedButton(
                    onPressed:
                        controller.isSubmitting.value
                            ? null
                            : () => controller.submitVerification(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.safetyBlue,
                      disabledBackgroundColor: AppColors.lightGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSize.m),
                      ),
                    ),
                    child:
                        controller.isSubmitting.value
                            ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : Text(
                              'Submit for Verification',
                              style: AppTextStyling.body_14M.copyWith(
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
              ),
              AppSize.lHeight,
            ],
          ),
        ),
      ),
    );
  }
}
