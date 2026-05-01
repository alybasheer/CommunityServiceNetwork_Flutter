import 'package:flutter/material.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:fyp_source_code/volunteer_side/profile/presentation/controller/profile_controller.dart';
import 'package:get/get.dart';

class ProfileHero extends StatelessWidget {
  final ProfileController controller;

  const ProfileHero({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: EdgeInsets.all(AppSize.l),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.safetyBlue, AppColors.steelBlue],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.steelBlue.withValues(alpha: 0.24),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: AppColors.pureWhite.withValues(alpha: 0.18),
                  child: Text(
                    controller.initials,
                    style: AppTextStyling.title_22L.copyWith(
                      color: AppColors.pureWhite,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(width: AppSize.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.profileName.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyling.title_18M.copyWith(
                          color: AppColors.pureWhite,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: AppSize.xsH),
                      Text(
                        controller.profileEmail.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyling.body_12S.copyWith(
                          color: AppColors.pureWhite.withValues(alpha: 0.86),
                        ),
                      ),
                    ],
                  ),
                ),
                _RolePill(
                  label: controller.displayRole,
                  icon: controller.roleIcon,
                ),
              ],
            ),
            SizedBox(height: AppSize.lH),
            Row(
              children: [
                Expanded(
                  child: _HeroInfo(
                    icon: Icons.verified_user_rounded,
                    label: 'Status',
                    value: controller.statusLabel,
                  ),
                ),
                SizedBox(width: AppSize.s),
                Expanded(
                  child: _HeroInfo(
                    icon: Icons.location_on_rounded,
                    label: 'Location',
                    value: controller.profileLocation.value,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileAccountSection extends StatelessWidget {
  final ProfileController controller;

  const ProfileAccountSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return _ProfileSection(
      title: 'Account Details',
      icon: Icons.badge_rounded,
      child: Column(
        children: [
          _ProfileTextField(
            controller: controller.nameController,
            label: 'Full name',
            icon: Icons.person_rounded,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: AppSize.sH),
          _ProfileTextField(
            controller: controller.emailController,
            label: 'Email',
            icon: Icons.email_rounded,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: AppSize.sH),
          _ProfileTextField(
            controller: controller.locationController,
            label: 'Location',
            icon: Icons.location_on_rounded,
            textInputAction: TextInputAction.done,
          ),
          SizedBox(height: AppSize.sH),
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => OutlinedButton.icon(
                    onPressed:
                        controller.isResolvingLocation.value
                            ? null
                            : controller.useCurrentLocation,
                    icon:
                        controller.isResolvingLocation.value
                            ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Icon(Icons.my_location_rounded),
                    label: Text(
                      controller.isResolvingLocation.value
                          ? 'Finding'
                          : 'Use Current',
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppSize.s),
              Expanded(
                child: Obx(
                  () => ElevatedButton.icon(
                    onPressed:
                        controller.isSaving.value
                            ? null
                            : controller.saveProfile,
                    icon:
                        controller.isSaving.value
                            ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : const Icon(Icons.save_rounded),
                    label: Text(controller.isSaving.value ? 'Saving' : 'Save'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.safetyBlue,
                      foregroundColor: AppColors.pureWhite,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileQuickActions extends StatelessWidget {
  final ProfileController controller;

  const ProfileQuickActions({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final actions = <_ProfileAction>[
        _ProfileAction(
          label: controller.isVolunteer ? 'Volunteer Home' : 'Request Home',
          icon: Icons.home_rounded,
          color: AppColors.safetyBlue,
          onTap: controller.openPrimaryWorkspace,
        ),
        _ProfileAction(
          label: 'Alerts',
          icon: Icons.notifications_active_rounded,
          color: AppColors.emergencyRed,
          onTap: controller.openAlerts,
        ),
        _ProfileAction(
          label: 'Coordination',
          icon: Icons.people_alt_rounded,
          color: AppColors.steelBlue,
          onTap: controller.openCoordination,
        ),
        if (controller.isVolunteer)
          _ProfileAction(
            label: 'Communities',
            icon: Icons.groups_rounded,
            color: AppColors.reliefGreen,
            onTap: controller.openCommunities,
          ),
      ];

      return _ProfileSection(
        title: 'Quick Actions',
        icon: Icons.grid_view_rounded,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = (constraints.maxWidth - AppSize.s) / 2;
            return Wrap(
              spacing: AppSize.s,
              runSpacing: AppSize.sH,
              children:
                  actions
                      .map(
                        (action) =>
                            _ActionTile(action: action, width: itemWidth),
                      )
                      .toList(),
            );
          },
        ),
      );
    });
  }
}

class ProfilePreferencesSection extends StatelessWidget {
  final ProfileController controller;

  const ProfilePreferencesSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return _ProfileSection(
      title: 'Preferences',
      icon: Icons.tune_rounded,
      child: Obx(
        () => SwitchListTile(
          contentPadding: EdgeInsets.zero,
          secondary: Icon(
            controller.isSwitching.value
                ? Icons.dark_mode_rounded
                : Icons.light_mode_rounded,
            color: AppColors.safetyBlue,
          ),
          title: Text(
            'Dark mode',
            style: AppTextStyling.body_14M.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          value: controller.isSwitching.value,
          activeThumbColor: AppColors.safetyBlue,
          onChanged: controller.onSwitch,
        ),
      ),
    );
  }
}

class ProfilePolicySection extends StatelessWidget {
  const ProfilePolicySection({super.key});

  @override
  Widget build(BuildContext context) {
    return _ProfileSection(
      title: 'Privacy',
      icon: Icons.policy_rounded,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.lock_rounded, color: AppColors.safetyBlue),
        title: Text(
          'Data and permissions',
          style: AppTextStyling.body_14M.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => _showPrivacySheet(context),
      ),
    );
  }

  void _showPrivacySheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(AppSize.l),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data and permissions',
                style: AppTextStyling.title_18M.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: AppSize.mH),
              _PolicyLine(
                icon: Icons.key_rounded,
                text: 'Your login token is stored locally for session access.',
              ),
              _PolicyLine(
                icon: Icons.location_on_rounded,
                text:
                    'Location is requested only when nearby services need it.',
              ),
              _PolicyLine(
                icon: Icons.palette_rounded,
                text: 'Theme and onboarding preferences stay on this device.',
              ),
              SizedBox(height: AppSize.mH),
            ],
          ),
        );
      },
    );
  }
}

class ProfileSignOutSection extends StatelessWidget {
  final ProfileController controller;

  const ProfileSignOutSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.buttonHeight,
      child: ElevatedButton.icon(
        onPressed: controller.signOut,
        icon: const Icon(Icons.logout_rounded),
        label: const Text('Sign out'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.emergencyRed,
          foregroundColor: AppColors.pureWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _ProfileSection({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.m),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.safetyBlue, size: 20),
              SizedBox(width: AppSize.xs),
              Text(
                title,
                style: AppTextStyling.title_16M.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.mH),
          child,
        ],
      ),
    );
  }
}

class _HeroInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _HeroInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.s),
      decoration: BoxDecoration(
        color: AppColors.pureWhite.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.pureWhite.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.pureWhite, size: 18),
          SizedBox(width: AppSize.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyling.body_12S.copyWith(
                    color: AppColors.pureWhite.withValues(alpha: 0.72),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyling.body_12S.copyWith(
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.w700,
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

class _RolePill extends StatelessWidget {
  final String label;
  final IconData icon;

  const _RolePill({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSize.s, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.pureWhite.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.pureWhite.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.pureWhite, size: 16),
          SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyling.body_12S.copyWith(
              color: AppColors.pureWhite,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  const _ProfileTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.steelBlue),
        filled: true,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.safetyBlue, width: 1.4),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final _ProfileAction action;
  final double width;

  const _ActionTile({required this.action, required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Material(
        color: action.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: action.onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: EdgeInsets.all(AppSize.s),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: action.color.withValues(alpha: 0.14),
                  child: Icon(action.icon, color: action.color, size: 18),
                ),
                SizedBox(width: AppSize.xs),
                Expanded(
                  child: Text(
                    action.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyling.body_12S.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
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
}

class _PolicyLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _PolicyLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSize.sH),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.safetyBlue, size: 20),
          SizedBox(width: AppSize.s),
          Expanded(
            child: Text(
              text,
              style: AppTextStyling.body_14M.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileAction {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ProfileAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
