import 'package:flutter/material.dart';
import 'package:fyp_source_code/admin/presentation/controller/admin_panel_controller.dart';
import 'package:fyp_source_code/admin/presentation/view/widgets/popup_card.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_widgets/app_bar.dart';
import 'package:fyp_source_code/utilities/reuse_widgets/shimmer_loading.dart';
import 'package:get/get.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(AdminPanelController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const WeHelpAppBar(
        title: 'Admin Panel',
        subtitle: 'Review volunteer applications',
        showBack: true,
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return AppShimmer(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: 6,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder:
                  (_, __) => const ShimmerListTileSkeleton(
                    showLeadingCircle: false,
                    subtitleLines: 1,
                  ),
            ),
          );
        }

        if (ctrl.res.isEmpty) {
          return const Center(child: Text('No pending volunteer applications'));
        }

        return ListView.builder(
          itemCount: ctrl.res.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 6.0,
                horizontal: 8.0,
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: Colors.white,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ctrl.res[index]['name'] ?? 'No Name',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    // Small status pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          ctrl.res[index]['status'],
                        ).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        ctrl.res[index]['status'],
                        style: TextStyle(
                          fontSize: 12,
                          color: _getStatusColor(ctrl.res[index]['status']),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  ctrl.res[index]['expertise'] ?? '',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.amberOrange,
                  size: 18,
                ),
                onTap: () => popupCard(context, ctrl.res[index]['_id'], index),
              ),
            );
          },
        );
      }),
    );
  }
}

Color _getStatusColor(String status) {
  switch (status) {
    case 'approved':
      return Colors.green;
    case 'pending':
      return Colors.orange;
    case 'rejected':
      return Colors.red;
    default:
      return Colors.grey;
  }
}
