import 'package:flutter/material.dart';
import 'package:fyp_source_code/admin/presentation/controller/admin_panel_controller.dart';
import 'package:fyp_source_code/admin/presentation/view/widgets/popup_card.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:get/get.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(AdminPanelController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel', style: AppTextStyling.title_18M),
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.amberOrange),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (ctrl.res.isEmpty) {
          return const Center(child: Text("Loading..."));
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
                        ).withOpacity(0.2),
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
