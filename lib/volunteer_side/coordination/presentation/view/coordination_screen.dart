import 'package:flutter/material.dart';
import 'package:fyp_source_code/help_requests/data/models/help_request_model.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:get/get.dart';

import '../controller/coordination_controller.dart';

class CoordinationScreen extends StatelessWidget {
  const CoordinationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CoordinationController controller =
        Get.isRegistered<CoordinationController>()
            ? Get.find<CoordinationController>()
            : Get.put(CoordinationController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.safetyBlue,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Coordination',
              style: AppTextStyling.title_18M.copyWith(
                color: AppColors.pureWhite,
              ),
            ),
            Text(
              'Live volunteer queue',
              style: AppTextStyling.body_12S.copyWith(
                color: AppColors.pureWhite.withOpacity(0.9),
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshRequests(),
          ),
        ],
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.value.isNotEmpty &&
              controller.filteredRequests.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(AppSize.l),
                child: Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: AppTextStyling.body_14M.copyWith(
                    color: AppColors.black,
                  ),
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.refreshRequests,
            child: ListView(
              padding: EdgeInsets.all(AppSize.m),
              children: [
                _QueueToggle(controller: controller),
                AppSize.mHeight,
                if (controller.filteredRequests.isEmpty)
                  Container(
                    padding: EdgeInsets.all(AppSize.l),
                    decoration: BoxDecoration(
                      color: AppColors.pureWhite,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.lightBorderGray),
                    ),
                    child: Text(
                      controller.showAccepted.value
                          ? 'No accepted requests yet'
                          : 'No open requests right now',
                      textAlign: TextAlign.center,
                      style: AppTextStyling.body_14M.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  )
                else
                  ...controller.filteredRequests.map(
                    (item) => _CoordinationRequestCard(
                      item: item,
                      showAccepted: controller.showAccepted.value,
                      onPrimaryAction: item.id == null
                          ? null
                          : () => controller.showAccepted.value
                              ? controller.resolveRequest(item.id!)
                              : controller.acceptRequest(item.id!),
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

class _QueueToggle extends StatelessWidget {
  const _QueueToggle({required this.controller});

  final CoordinationController controller;

  @override
  Widget build(BuildContext context) {
    final showAccepted = controller.showAccepted.value;
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => controller.setShowAccepted(false),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: AppSize.sH),
              decoration: BoxDecoration(
                color: !showAccepted
                    ? AppColors.safetyBlue
                    : AppColors.pureWhite,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.safetyBlue),
              ),
              alignment: Alignment.center,
              child: Text(
                'Open',
                style: AppTextStyling.body_12S.copyWith(
                  color: !showAccepted
                      ? AppColors.pureWhite
                      : AppColors.safetyBlue,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: AppSize.s),
        Expanded(
          child: GestureDetector(
            onTap: () => controller.setShowAccepted(true),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: AppSize.sH),
              decoration: BoxDecoration(
                color: showAccepted
                    ? AppColors.safetyBlue
                    : AppColors.pureWhite,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.safetyBlue),
              ),
              alignment: Alignment.center,
              child: Text(
                'Accepted',
                style: AppTextStyling.body_12S.copyWith(
                  color: showAccepted
                      ? AppColors.pureWhite
                      : AppColors.safetyBlue,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CoordinationRequestCard extends StatelessWidget {
  const _CoordinationRequestCard({
    required this.item,
    required this.showAccepted,
    required this.onPrimaryAction,
  });

  final HelpRequestModel item;
  final bool showAccepted;
  final VoidCallback? onPrimaryAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSize.sH),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(AppSize.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: item.isSOS
                      ? AppColors.emergencyRed
                      : AppColors.amberOrange,
                  child: Icon(
                    item.isSOS ? Icons.sos : Icons.campaign_outlined,
                    color: AppColors.pureWhite,
                  ),
                ),
                SizedBox(width: AppSize.s),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.description ?? 'Help request',
                        maxLines: 2,
                        style: AppTextStyling.title_16M.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(height: AppSize.xsH),
                      Text(
                        _coordinationMeta(item),
                        style: AppTextStyling.body_12S.copyWith(
                          color: AppColors.mediumGray,
                        ),
                      ),
                    ],
                  ),
                ),
                _CoordinationChip(
                  label: item.isSOS == true ? 'SOS' : (item.urgency ?? 'open'),
                  color: item.isSOS == true
                      ? AppColors.emergencyRed
                      : _coordinationUrgencyColor(item.urgency),
                ),
              ],
            ),
            SizedBox(height: AppSize.sH),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: AppColors.mediumGray,
                ),
                SizedBox(width: AppSize.xs),
                Expanded(
                  child: Text(
                    _coordinationLocation(item),
                    style: AppTextStyling.body_12S.copyWith(
                      color: AppColors.mediumGray,
                    ),
                  ),
                ),
                SizedBox(width: AppSize.s),
                Text(
                  _coordinationTimeAgo(item.createdAt),
                  style: AppTextStyling.body_12S.copyWith(
                    color: AppColors.mediumGray,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSize.mH),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onPrimaryAction,
                icon: Icon(showAccepted ? Icons.check_circle : Icons.touch_app),
                label: Text(showAccepted ? 'Resolve Request' : 'Accept Request'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: showAccepted
                      ? AppColors.reliefGreen
                      : AppColors.safetyBlue,
                  foregroundColor: AppColors.pureWhite,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoordinationChip extends StatelessWidget {
  const _CoordinationChip({required this.label, required this.color});

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

String _coordinationMeta(HelpRequestModel item) {
  final category = (item.category ?? 'other').replaceAll('_', ' ');
  return '${category[0].toUpperCase()}${category.substring(1)} - ${item.status ?? 'open'}';
}

String _coordinationLocation(HelpRequestModel item) {
  if ((item.locationLabel ?? '').trim().isNotEmpty) {
    return item.locationLabel!;
  }
  if (item.latitude != null && item.longitude != null) {
    return '${item.latitude!.toStringAsFixed(4)}, ${item.longitude!.toStringAsFixed(4)}';
  }
  return 'Location unavailable';
}

String _coordinationTimeAgo(String? timestamp) {
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

Color _coordinationUrgencyColor(String? urgency) {
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
