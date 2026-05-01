import 'package:flutter/material.dart';
import 'package:fyp_source_code/request_side/create_help_request/data/model/help_request.dart';
import 'package:get/get.dart';
import 'package:fyp_source_code/request_side/home/presentation/controller/request_home_controller.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:fyp_source_code/utilities/reuse_widgets/app_bar.dart';
import 'package:fyp_source_code/utilities/reuse_widgets/shimmer_loading.dart';

class RequestHomeScreen extends StatelessWidget {
  const RequestHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RequestHomeController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const WeHelpAppBar(
        title: 'Request Home',
        subtitle: 'Nearby volunteers and emergency help',
      ),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: controller.refreshDashboard,
          child: ListView(
            padding: EdgeInsets.all(AppSize.m),
            children: [
              _SectionTitle(title: 'Nearby Active Volunteers'),
              SizedBox(height: AppSize.sH),
              if (controller.isLoading.value)
                AppShimmer(
                  child: Column(
                    children: List.generate(
                      3,
                      (index) => Padding(
                        padding: EdgeInsets.only(bottom: AppSize.sH),
                        child: const ShimmerListTileSkeleton(),
                      ),
                    ),
                  ),
                )
              else if (controller.nearbyVolunteers.isEmpty)
                _EmptyBox(text: 'No active volunteers nearby right now.')
              else
                ...controller.nearbyVolunteers.map(_VolunteerTile.new),
              if (controller.activeRequests.isNotEmpty) ...[
                SizedBox(height: AppSize.lH),
                _SectionTitle(title: 'My Active Requests'),
                SizedBox(height: AppSize.sH),
                ...controller.activeRequests.map(_RequestTile.new),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: _RequestBottomNavBar(controller: controller),
      floatingActionButton: Obx(
        () => FloatingActionButton.extended(
          onPressed: controller.isSendingSos.value ? null : controller.sendSos,
          backgroundColor: AppColors.emergencyRed,
          icon: const Icon(Icons.sos, color: Colors.white),
          label: Text(
            controller.isSendingSos.value ? 'Sending' : 'SOS',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _RequestBottomNavBar extends StatelessWidget {
  final RequestHomeController controller;

  const _RequestBottomNavBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.s, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isActive: true,
                onTap: () {},
              ),
              _NavItem(
                icon: Icons.notifications_active_rounded,
                label: 'Alerts',
                isActive: false,
                onTap: controller.openAlerts,
              ),
              _NavItem(
                icon: Icons.add_circle_outline_rounded,
                label: 'Help',
                isActive: false,
                onTap: controller.openRequestHelpSheet,
              ),
              _NavItem(
                icon: Icons.people_alt_rounded,
                label: 'Coordination',
                isActive: false,
                onTap: controller.openCoordination,
              ),
              _NavItem(
                icon: Icons.person_rounded,
                label: 'Profile',
                isActive: false,
                onTap: controller.openProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isActive ? AppColors.steelBlue : AppColors.mediumGray,
                size: 26,
              ),
              SizedBox(height: AppSize.xsH),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyling.body_12S.copyWith(
                  color: isActive ? AppColors.steelBlue : AppColors.mediumGray,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyling.title_16M.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _VolunteerTile extends StatelessWidget {
  final NearbyVolunteer volunteer;

  const _VolunteerTile(this.volunteer);

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      icon: Icons.volunteer_activism,
      iconColor: AppColors.reliefGreen,
      title: volunteer.name,
      subtitle: volunteer.expertise,
      trailing: '${volunteer.rating.toStringAsFixed(1)} rating',
    );
  }
}

class _RequestTile extends StatelessWidget {
  final HelpRequest request;

  const _RequestTile(this.request);

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      icon: request.isSos ? Icons.sos : Icons.support_agent,
      iconColor: request.isSos ? AppColors.emergencyRed : AppColors.steelBlue,
      title: request.displayTitle,
      subtitle: request.displayLocation,
      trailing: request.status ?? 'active',
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String trailing;

  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSize.sH),
      padding: EdgeInsets.all(AppSize.m),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withValues(alpha: 0.12),
            child: Icon(icon, color: iconColor),
          ),
          SizedBox(width: AppSize.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyling.title_16M.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppSize.xsH),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyling.body_12S.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSize.s),
          Text(
            trailing,
            style: AppTextStyling.body_12S.copyWith(color: AppColors.steelBlue),
          ),
        ],
      ),
    );
  }
}

class _EmptyBox extends StatelessWidget {
  final String text;

  const _EmptyBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.m),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Text(
        text,
        style: AppTextStyling.body_14M.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
