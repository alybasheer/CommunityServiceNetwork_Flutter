import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_source_code/auth/presentation/view/widgets/verification_image_picker.dart';
import 'package:fyp_source_code/auth/presentation/view/widgets/verification_submit_button.dart';
import 'package:fyp_source_code/auth/presentation/view/widgets/verification_text_field.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:fyp_source_code/utilities/reuse_widgets/app_bar.dart';
import 'package:fyp_source_code/volunteer_side/volunteer_verification/presentation/controller/volunteer_verification_controller.dart';
import 'package:get/get.dart';

class VolunteerVerficationScreen extends StatelessWidget {
  const VolunteerVerficationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VolunteerVerificationController());
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const WeHelpAppBar(
        title: 'Volunteer Verification',
        subtitle: 'Submit your details for admin review',
        showBack: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSize.l),
          child: Form(
            key: controller.verificationFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSize.lHeight,
                Text(
                  'Complete Your Volunteer Profile',
                  style: AppTextStyling.title_30M.copyWith(
                    color: AppColors.safetyBlue,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                AppSize.mHeight,
                Text(
                  'CNIC front and back images are required for verification. Profile photo is optional and will be used as your avatar.',
                  style: AppTextStyling.body_12S.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
                AppSize.xxlHeight,
                _ReadOnlyInfoField(
                  label: 'Account Email',
                  value: controller.emailController.text,
                  icon: Icons.email_outlined,
                ),
                AppSize.lHeight,
                Obx(
                  () => VerificationImagePicker(
                    label: 'CNIC Front',
                    helperText: 'Upload a clear front-side image of your national ID card.',
                    isRequired: true,
                    imageBytes: controller.cnicFrontPhoto.value?.bytes,
                    fileName: controller.cnicFrontPhoto.value?.name,
                    onTap: controller.pickCnicFrontPhoto,
                    isLoading: controller.isSubmitting.value,
                  ),
                ),
                Obx(
                  () => VerificationImagePicker(
                    label: 'CNIC Back',
                    helperText: 'Upload the back-side image so admin can verify the document properly.',
                    isRequired: true,
                    imageBytes: controller.cnicBackPhoto.value?.bytes,
                    fileName: controller.cnicBackPhoto.value?.name,
                    onTap: controller.pickCnicBackPhoto,
                    isLoading: controller.isSubmitting.value,
                  ),
                ),
                Obx(
                  () => VerificationImagePicker(
                    label: 'Profile Photo',
                    helperText: 'Optional. If added, it will appear as your volunteer profile avatar.',
                    imageBytes: controller.profilePhoto.value?.bytes,
                    fileName: controller.profilePhoto.value?.name,
                    onTap: controller.pickProfilePhoto,
                    isLoading: controller.isSubmitting.value,
                  ),
                ),
                VerificationTextField(
                  label: 'Full Name',
                  hintText: 'Enter your full name',
                  controller: controller.fullNameController,
                  validator: controller.validateFullName,
                  keyboardType: TextInputType.name,
                  prefixIcon: Icons.person_outline,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s']")),
                  ],
                ),
                VerificationTextField(
                  label: 'Area of Expertise',
                  hintText: 'Medical, Search & Rescue, Logistics',
                  controller: controller.expertiseController,
                  validator: controller.validateExpertise,
                  keyboardType: TextInputType.text,
                  prefixIcon: Icons.school_outlined,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r"[a-zA-Z0-9\s,&\-]"),
                    ),
                  ],
                ),
                VerificationTextField(
                  label: 'CNIC Number',
                  hintText: 'XXXXX-XXXXXXX-X',
                  controller: controller.cnicController,
                  validator: controller.validateCNIC,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.badge_outlined,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]')),
                  ],
                ),
                VerificationTextField(
                  label: 'City',
                  hintText: 'Enter your city',
                  controller: controller.cityController,
                  validator: controller.validateCity,
                  keyboardType: TextInputType.text,
                  prefixIcon: Icons.location_city_outlined,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r"[a-zA-Z\s'-]"),
                    ),
                  ],
                ),
                VerificationTextField(
                  label: 'Location / Address',
                  hintText: 'Enter your detailed location',
                  controller: controller.locationController,
                  validator: controller.validateLocation,
                  keyboardType: TextInputType.text,
                  prefixIcon: Icons.location_on_outlined,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r"[a-zA-Z0-9\s,\-/\.()']"),
                    ),
                  ],
                ),
                VerificationTextField(
                  label: 'Why do you want to volunteer?',
                  hintText: 'Share your motivation and how you can help.',
                  controller: controller.descriptionController,
                  validator: controller.validateDescription,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  prefixIcon: Icons.edit_outlined,
                ),
                AppSize.xxxlHeight,
                Obx(
                  () => VerificationSubmitButton(
                    isLoading: controller.isSubmitting.value,
                    onPressed: controller.submitVerification,
                    label: 'Submit for Verification',
                  ),
                ),
                AppSize.xxxlHeight,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReadOnlyInfoField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ReadOnlyInfoField({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyling.body_12S.copyWith(
            color: scheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        AppSize.xsHeight,
        Container(
          height: 54,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: theme.inputDecorationTheme.fillColor ?? scheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Row(
            children: [
              Icon(icon, color: scheme.primary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  value.trim().isEmpty ? 'No email found' : value.trim(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyling.body_14M.copyWith(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
