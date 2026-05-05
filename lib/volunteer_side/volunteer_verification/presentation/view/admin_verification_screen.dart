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
      bottomNavigationBar: SafeArea(
        minimum: EdgeInsets.fromLTRB(AppSize.l, 8, AppSize.l, AppSize.m),
        child: Obx(
          () => VerificationSubmitButton(
            isLoading: controller.isSubmitting.value,
            onPressed: controller.submitVerification,
            label: 'Submit for Verification',
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(AppSize.l, AppSize.m, AppSize.l, 18),
          child: Form(
            key: controller.verificationFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _IntroPanel(scheme: scheme),
                AppSize.lHeight,
                _SectionTitle(
                  title: 'Account',
                  subtitle: 'This email is attached to your login session.',
                ),
                _ReadOnlyInfoField(
                  label: 'Account Email',
                  value: controller.emailController.text,
                  icon: Icons.email_outlined,
                ),
                AppSize.xxlHeight,
                _SectionTitle(
                  title: 'Identity Documents',
                  subtitle:
                      'CNIC front and back are required. Profile photo is optional.',
                ),
                Obx(
                  () => VerificationImagePicker(
                    label: 'CNIC Front',
                    helperText:
                        'Upload a clear front-side image of your national ID card.',
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
                    helperText:
                        'Upload the back-side image so admin can verify the document properly.',
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
                    helperText:
                        'Optional. If added, it will appear as your volunteer profile avatar.',
                    imageBytes: controller.profilePhoto.value?.bytes,
                    fileName: controller.profilePhoto.value?.name,
                    onTap: controller.pickProfilePhoto,
                    isLoading: controller.isSubmitting.value,
                  ),
                ),
                Obx(
                  () => _UploadProgress(
                    readyCount:
                        (controller.cnicFrontPhoto.value == null ? 0 : 1) +
                        (controller.cnicBackPhoto.value == null ? 0 : 1),
                  ),
                ),
                AppSize.xxlHeight,
                const _SectionTitle(
                  title: 'Personal Details',
                  subtitle:
                      'Use the same details that appear on your verification documents.',
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
                AppSize.xxlHeight,
                const _SectionTitle(
                  title: 'Live Location',
                  subtitle:
                      'Add your current area so admin can verify availability and nearby response coverage.',
                ),
                Obx(
                  () => _CurrentLocationButton(
                    isLoading: controller.isResolvingLocation.value,
                    hasCoordinates:
                        controller.latitude.value != null &&
                        controller.longitude.value != null,
                    onPressed: controller.useCurrentLocation,
                  ),
                ),
                AppSize.mHeight,
                VerificationTextField(
                  label: 'City',
                  hintText: 'Enter your city',
                  controller: controller.cityController,
                  validator: controller.validateCity,
                  keyboardType: TextInputType.text,
                  prefixIcon: Icons.location_city_outlined,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s'-]")),
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
                Obx(() {
                  final lat = controller.latitude.value;
                  final lng = controller.longitude.value;
                  if (lat == null || lng == null) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 2, bottom: 14),
                    child: Text(
                      'GPS attached: ${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)}',
                      style: AppTextStyling.body_12S.copyWith(
                        color: AppColors.reliefGreen,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                }),
                AppSize.xxlHeight,
                const _SectionTitle(
                  title: 'Motivation',
                  subtitle:
                      'Briefly explain your skills and how you can support people.',
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
                AppSize.lHeight,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IntroPanel extends StatelessWidget {
  final ColorScheme scheme;

  const _IntroPanel({required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.verified_user_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verify your identity',
                  maxLines: 2,
                  style: AppTextStyling.title_18M.copyWith(
                    color: AppColors.safetyBlue,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Upload CNIC front/back, add your current location, and submit for admin review.',
                  style: AppTextStyling.body_12S.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyling.body_14M.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyling.body_12S.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadProgress extends StatelessWidget {
  final int readyCount;

  const _UploadProgress({required this.readyCount});

  @override
  Widget build(BuildContext context) {
    final complete = readyCount == 2;
    final color = complete ? AppColors.reliefGreen : AppColors.amberOrange;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            complete ? Icons.check_circle_rounded : Icons.info_rounded,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$readyCount/2 required CNIC images selected',
              style: AppTextStyling.body_12S.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrentLocationButton extends StatelessWidget {
  final bool isLoading;
  final bool hasCoordinates;
  final VoidCallback onPressed;

  const _CurrentLocationButton({
    required this.isLoading,
    required this.hasCoordinates,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon:
            isLoading
                ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                : Icon(
                  hasCoordinates
                      ? Icons.my_location_rounded
                      : Icons.location_searching_rounded,
                ),
        label: Text(
          isLoading
              ? 'Detecting location...'
              : hasCoordinates
              ? 'Update Current Location'
              : 'Use Current Location',
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor:
              hasCoordinates ? AppColors.reliefGreen : scheme.primary,
          side: BorderSide(
            color:
                hasCoordinates
                    ? AppColors.reliefGreen.withValues(alpha: 0.45)
                    : scheme.outlineVariant,
          ),
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
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
