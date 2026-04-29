import 'package:flutter/material.dart';
import 'package:fyp_source_code/help_requests/data/models/help_request_model.dart';
import 'package:fyp_source_code/routing/route_names.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:fyp_source_code/volunteer_side/home/presentation/controller/home_controller.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.isRegistered<HomeController>()
            ? Get.find<HomeController>()
            : Get.put(HomeController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        foregroundColor: AppColors.darkGray,
        elevation: 0,
        title: Obx(
          () => Text(
            controller.isVolunteer ? 'Volunteer Dashboard' : 'My Requests',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => controller.refreshRequests(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.value.isNotEmpty &&
              controller.requests.isEmpty) {
            return _ErrorState(
              message: controller.errorMessage.value,
              onRetry: controller.loadRequests,
            );
          }

          return RefreshIndicator(
            onRefresh: controller.refreshRequests,
            child: ListView(
              padding: EdgeInsets.all(AppSize.m),
              children: [
                _DashboardHeader(controller: controller),
                AppSize.mHeight,
                _ActionRow(controller: controller),
                AppSize.lHeight,
                Text(
                  controller.isVolunteer
                      ? 'Assigned Requests'
                      : 'Submitted Requests',
                  style: AppTextStyling.title_18M.copyWith(
                    color: AppColors.darkGray,
                  ),
                ),
                AppSize.sHeight,
                if (controller.requests.isEmpty)
                  _EmptyState(isVolunteer: controller.isVolunteer)
                else
                  ...controller.requests.map(
                    (request) => _RequestCard(
                      request: request,
                      isVolunteer: controller.isVolunteer,
                      onCancel: request.id == null
                          ? null
                          : () => controller.cancelRequest(request.id!),
                      onResolve: request.id == null
                          ? null
                          : () => controller.resolveRequest(request.id!),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.m),
      decoration: BoxDecoration(
        color: AppColors.safetyBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.isVolunteer
                ? 'Live assignment feed'
                : 'Your live help activity',
            style: AppTextStyling.title_18M.copyWith(color: AppColors.white),
          ),
          AppSize.sHeight,
          Text(
            controller.isVolunteer
                ? 'This view refreshes automatically with assigned requests.'
                : 'Every request you submit is pulled from the backend here.',
            style: AppTextStyling.body_12S.copyWith(color: AppColors.white),
          ),
          AppSize.mHeight,
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  label: 'Open',
                  count: '${controller.openCount}',
                ),
              ),
              AppSize.sWidth,
              Expanded(
                child: _StatTile(
                  label: 'Active',
                  count: '${controller.activeCount}',
                ),
              ),
              AppSize.sWidth,
              Expanded(
                child: _StatTile(
                  label: 'Resolved',
                  count: '${controller.resolvedCount}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!controller.isVolunteer)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => Get.toNamed(RouteNames.requestHelp),
              icon: const Icon(Icons.add_alert),
              label: const Text('New Request'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.emergencyRed,
                foregroundColor: AppColors.white,
                minimumSize: Size(double.infinity, AppSize.buttonHeight),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        if (controller.isVolunteer)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => Get.toNamed(RouteNames.coordination),
              icon: const Icon(Icons.people_alt_rounded),
              label: const Text('Open Queue'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.safetyBlue,
                foregroundColor: AppColors.white,
                minimumSize: Size(double.infinity, AppSize.buttonHeight),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.request,
    required this.isVolunteer,
    required this.onCancel,
    required this.onResolve,
  });

  final HelpRequestModel request;
  final bool isVolunteer;
  final VoidCallback? onCancel;
  final VoidCallback? onResolve;

  @override
  Widget build(BuildContext context) {
    final status = request.status ?? 'unknown';
    final canCancel = !isVolunteer && status == 'open' && onCancel != null;
    final canResolve = status == 'in_progress' && onResolve != null;

    return Card(
      margin: EdgeInsets.only(bottom: AppSize.sH),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.all(AppSize.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.description ?? 'Help request',
                        maxLines: 2,
                        style: AppTextStyling.title_16M.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                      AppSize.xsHeight,
                      Text(
                        _metaLine(request),
                        style: AppTextStyling.body_12S.copyWith(
                          color: AppColors.mediumGray,
                        ),
                      ),
                    ],
                  ),
                ),
                AppSize.sWidth,
                _StatusChip(
                  label: request.isSOS == true
                      ? 'SOS'
                      : (request.urgency ?? 'normal'),
                  color: request.isSOS == true
                      ? AppColors.emergencyRed
                      : _urgencyColor(request.urgency),
                ),
              ],
            ),
            AppSize.sHeight,
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: AppColors.mediumGray,
                ),
                AppSize.xsWidth,
                Expanded(
                  child: Text(
                    _locationLabel(request),
                    style: AppTextStyling.body_12S.copyWith(
                      color: AppColors.mediumGray,
                    ),
                  ),
                ),
                AppSize.sWidth,
                _StatusChip(
                  label: status.replaceAll('_', ' '),
                  color: _statusColor(status),
                ),
              ],
            ),
            AppSize.sHeight,
            Text(
              _timeAgo(request.createdAt),
              style: AppTextStyling.body_12S.copyWith(
                color: AppColors.mediumGray,
              ),
            ),
            if (canCancel || canResolve) ...[
              AppSize.mHeight,
              Row(
                children: [
                  if (canCancel)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onCancel,
                        child: const Text('Cancel'),
                      ),
                    ),
                  if (canCancel && canResolve) AppSize.sWidth,
                  if (canResolve)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onResolve,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.reliefGreen,
                          foregroundColor: AppColors.white,
                        ),
                        child: const Text('Resolve'),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.count});

  final String label;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSize.s, vertical: AppSize.sH),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: AppTextStyling.title_18M.copyWith(color: AppColors.white),
          ),
          Text(
            label,
            style: AppTextStyling.body_12S.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSize.s, vertical: AppSize.xsH),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyling.body_12S.copyWith(color: color),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isVolunteer});

  final bool isVolunteer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.l),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.lightBorderGray),
      ),
      child: Column(
        children: [
          Icon(
            isVolunteer ? Icons.assignment_outlined : Icons.inbox_outlined,
            size: 40,
            color: AppColors.safetyBlue,
          ),
          AppSize.sHeight,
          Text(
            isVolunteer
                ? 'No assigned requests yet'
                : 'You have not submitted any requests yet',
            style: AppTextStyling.title_16M.copyWith(color: AppColors.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSize.l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 36, color: AppColors.emergencyRed),
            AppSize.sHeight,
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyling.body_14M.copyWith(color: AppColors.black),
            ),
            AppSize.mHeight,
            ElevatedButton(
              onPressed: () => onRetry(),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

String _metaLine(HelpRequestModel request) {
  final category = (request.category ?? 'other').toString().replaceAll('_', ' ');
  return '${category[0].toUpperCase()}${category.substring(1)}'
      '${request.responderId != null ? ' - Assigned' : ''}';
}

String _locationLabel(HelpRequestModel request) {
  if ((request.locationLabel ?? '').toString().trim().isNotEmpty) {
    return request.locationLabel.toString();
  }
  if (request.latitude != null && request.longitude != null) {
    return '${request.latitude!.toStringAsFixed(4)}, ${request.longitude!.toStringAsFixed(4)}';
  }
  return 'Location unavailable';
}

String _timeAgo(String? timestamp) {
  if (timestamp == null || timestamp.isEmpty) {
    return 'Just now';
  }
  final dateTime = DateTime.tryParse(timestamp)?.toLocal();
  if (dateTime == null) {
    return 'Just now';
  }
  final difference = DateTime.now().difference(dateTime);
  if (difference.inMinutes < 1) {
    return 'Just now';
  }
  if (difference.inHours < 1) {
    return '${difference.inMinutes} min ago';
  }
  if (difference.inDays < 1) {
    return '${difference.inHours} hr ago';
  }
  return '${difference.inDays} day ago';
}

Color _statusColor(String status) {
  switch (status) {
    case 'open':
      return AppColors.amberOrange;
    case 'in_progress':
      return AppColors.safetyBlue;
    case 'resolved':
      return AppColors.reliefGreen;
    case 'cancelled':
      return AppColors.mediumGray;
    default:
      return AppColors.darkGray;
  }
}

Color _urgencyColor(String? urgency) {
  switch (urgency) {
    case 'critical':
      return AppColors.emergencyRed;
    case 'high':
      return AppColors.amberOrange;
    case 'medium':
      return AppColors.safetyBlue;
    default:
      return AppColors.reliefGreen;
  }
}
