import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyp_source_code/admin/presentation/controller/admin_panel_controller.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
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
          icon: Icon(Icons.arrow_back, color: AppColors.darkGray),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          final items = ctrl.submissions;
          if (items.isEmpty) {
            return Center(
              child: Text('No submissions', style: AppTextStyling.body_14M),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(AppSize.m),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final s = items[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: AppSize.sH),
                child: Padding(
                  padding: EdgeInsets.all(AppSize.m),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // image or placeholder
                          Container(
                            height: 64,
                            width: 64,
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(AppSize.s),
                            ),
                            child:
                                s.imagePath != null
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        AppSize.s,
                                      ),
                                      child: Image.file(
                                        File(s.imagePath!),
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                    : Icon(
                                      Icons.person,
                                      size: 36,
                                      color: AppColors.grey,
                                    ),
                          ),
                          AppSize.mWidth,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      s.fullName,
                                      style: AppTextStyling.title_16M,
                                    ),
                                    // status
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: AppSize.s,
                                        vertical: AppSize.xsH,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            s.status == 'pending'
                                                ? AppColors.amberOrange
                                                    .withOpacity(0.12)
                                                : s.status == 'approved'
                                                ? AppColors.reliefGreen
                                                    .withOpacity(0.12)
                                                : Colors.red.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        s.status.toUpperCase(),
                                        style: AppTextStyling.body_12S.copyWith(
                                          color:
                                              s.status == 'pending'
                                                  ? AppColors.amberOrange
                                                  : s.status == 'approved'
                                                  ? AppColors.reliefGreen
                                                  : Colors.red,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                AppSize.sHeight,
                                Text(
                                  '${s.expertise} • CNIC: ${s.cnicNumber}',
                                  style: AppTextStyling.body_12S.copyWith(
                                    color: AppColors.mediumGray,
                                  ),
                                ),
                                AppSize.sHeight,
                                Text(
                                  s.description,
                                  style: AppTextStyling.body_12S,
                                ),
                                AppSize.mHeight,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Location: ${s.location}',
                                      style: AppTextStyling.body_12S.copyWith(
                                        color: AppColors.mediumGray,
                                      ),
                                    ),
                                    Text(
                                      '${s.submittedAt.toLocal()}'.split(
                                        '.',
                                      )[0],
                                      style: AppTextStyling.body_12S.copyWith(
                                        color: AppColors.mediumGray,
                                      ),
                                    ),
                                  ],
                                ),
                                AppSize.mHeight,
                                // Action buttons
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed:
                                            s.status == 'approved'
                                                ? null
                                                : () => ctrl.approve(s.id),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.reliefGreen,
                                        ),
                                        child: Text(
                                          'Approve',
                                          style: AppTextStyling.body_14M
                                              .copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    AppSize.mWidth,
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed:
                                            s.status == 'disapproved'
                                                ? null
                                                : () => ctrl.disapprove(s.id),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.emergencyRed,
                                        ),
                                        child: Text(
                                          'Disapprove',
                                          style: AppTextStyling.body_14M
                                              .copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
