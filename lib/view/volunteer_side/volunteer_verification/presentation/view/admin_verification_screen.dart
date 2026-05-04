import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_source_code/view/volunteer_side/volunteer_verification/presentation/controller/volunteer_verification_controller.dart';
import 'package:fyp_source_code/view/auth/presentation/view/widgets/verification_image_picker.dart';
import 'package:fyp_source_code/view/auth/presentation/view/widgets/verification_submit_button.dart';
import 'package:fyp_source_code/view/auth/presentation/view/widgets/verification_text_field.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:fyp_source_code/utilities/reuse_widgets/app_bar.dart';
import 'package:get/get.dart';

class VolunteerVerficationScreen extends StatelessWidget {
  const VolunteerVerficationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VolunteerVerificationController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const WeHelpAppBar(
        title: 'Volunteer Verification',
        subtitle: 'Complete your details for review',
        showBack: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.l),
            child: Form(
              key: controller.verificationFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSize.lHeight,

                  // HEADER
                  Text(
                    'Complete Your Profile',
                    style: AppTextStyling.title_30M.copyWith(
                      color: AppColors.safetyBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSize.mHeight,
                  Text(
                    'Provide your details for admin verification',
                    style: AppTextStyling.body_12S.copyWith(
                      color: AppColors.grey,
                      height: 1.5,
                    ),
                  ),
                  AppSize.xxxlHeight,

                  // PROFILE PHOTO
                  Obx(
                    () => VerificationImagePicker(
                      selectedImagePath: controller.selectedImagePath.value,
                      onTap: () {
                        // TODO: Implement image picker with image_picker package
                        Get.snackbar('Info', 'Image picker to be implemented');
                      },
                      isLoading: controller.isSubmitting.value,
                    ),
                  ),

                  // FULL NAME FIELD
                  VerificationTextField(
                    label: 'Full Name',
                    hintText: 'Alee',
                    controller: controller.fullNameController,
                    validator: (val) => controller.validateFullName(val),
                    keyboardType: TextInputType.name,
                    prefixIcon: Icons.person_outline,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(
                          r"[a-zA-Z\s']",
                        ), // Allow only letters, spaces, and apostrophes
                      ),
                    ],
                  ),

                  // EMAIL FIELD
                  VerificationTextField(
                    label: 'Email Address',
                    hintText: 'alee@example.com',
                    controller: TextEditingController(
                      text: controller.fullNameController.text,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: (val) => controller.validateEmail(val),
                  ),

                  // EXPERTISE FIELD
                  VerificationTextField(
                    label: 'Area of Expertise',
                    hintText: 'e.g., Medical, Search & Rescue, Logistics',
                    controller: controller.expertiseController,
                    validator: (val) => controller.validateExpertise(val),
                    keyboardType: TextInputType.text,
                    prefixIcon: Icons.school_outlined,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(
                          r"[a-zA-Z0-9\s,&\-]",
                        ), // Allow letters, numbers, spaces, commas, ampersands, hyphens
                      ),
                    ],
                  ),

                  // CNIC FIELD
                  VerificationTextField(
                    label: 'CNIC Number',
                    hintText: 'Format: XXXXX-XXXXXXX-X',
                    controller: controller.cnicController,
                    validator: (val) => controller.validateCNIC(val),
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.card_membership_outlined,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9\-]'),
                      ), // Only digits and hyphens
                    ],
                  ),

                  // CITY FIELD
                  VerificationTextField(
                    label: 'City',
                    hintText: 'Enter your city',
                    controller: controller.cityController,
                    validator: (val) => controller.validateCity(val),
                    keyboardType: TextInputType.text,
                    prefixIcon: Icons.location_city_outlined,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(
                          r"[a-zA-Z\s'-]",
                        ), // Allow letters, spaces, hyphens, apostrophes
                      ),
                    ],
                  ),

                  // LOCATION FIELD
                  VerificationTextField(
                    label: 'Location/Address',
                    hintText: 'Enter your detailed location',
                    controller: controller.locationController,
                    validator: (val) => controller.validateLocation(val),
                    keyboardType: TextInputType.text,
                    prefixIcon: Icons.location_on_outlined,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(
                          r"[a-zA-Z0-9\s,\-/\.()']",
                        ), // Allow alphanumeric, spaces, commas, hyphens, slashes, dots, parentheses
                      ),
                    ],
                  ),

                  // DESCRIPTION/REASON FIELD
                  VerificationTextField(
                    label: 'Why do you want to volunteer?',
                    hintText: 'Tell us your motivation for volunteering...',
                    controller: controller.descriptionController,
                    validator: (val) => controller.validateDescription(val),
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    prefixIcon: Icons.edit_outlined,
                  ),

                  AppSize.xxxlHeight,

                  // SUBMIT BUTTON
                  Obx(
                    () => VerificationSubmitButton(
                      isLoading: controller.isSubmitting.value,
                      onPressed: () => controller.submitVerification(),
                      label: 'Submit for Verification',
                    ),
                  ),

                  AppSize.xxxlHeight,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
