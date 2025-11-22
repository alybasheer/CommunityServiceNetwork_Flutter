import 'package:flutter/material.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:get/get.dart';

import '../controller/coordination_controller.dart';

class CoordinationScreen extends StatelessWidget {
  const CoordinationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CoordinationController controller = Get.put(CoordinationController());

    return Scaffold(
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
              'Manage volunteers by request',
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
      ),
      body: Column(
        children: [
          SizedBox(height: AppSize.mH),

          // Toggle: Accepted / All
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.m),
            child: Obx(() {
              final showAccepted = controller.showAccepted.value;
              return Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.setShowAccepted(true),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: AppSize.sH),
                        decoration: BoxDecoration(
                          color:
                              showAccepted
                                  ? AppColors.safetyBlue
                                  : AppColors.pureWhite,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: AppColors.safetyBlue),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Accepted',
                          style: AppTextStyling.body_12S.copyWith(
                            color:
                                showAccepted
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
                      onTap: () => controller.setShowAccepted(false),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: AppSize.sH),
                        decoration: BoxDecoration(
                          color:
                              !showAccepted
                                  ? AppColors.safetyBlue
                                  : AppColors.pureWhite,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: AppColors.safetyBlue),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'All',
                          style: AppTextStyling.body_12S.copyWith(
                            color:
                                !showAccepted
                                    ? AppColors.pureWhite
                                    : AppColors.safetyBlue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),

          SizedBox(height: AppSize.mH),

          // List
          Expanded(
            child: Obx(() {
              final list = controller.filteredRequests;
              if (list.isEmpty) {
                return Center(
                  child: Text('No requests', style: AppTextStyling.body_14M),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.symmetric(vertical: AppSize.sH),
                itemCount: list.length,
                separatorBuilder: (_, __) => SizedBox(height: AppSize.xsH),
                itemBuilder: (context, index) {
                  final item = list[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.m),
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: EdgeInsets.all(AppSize.m),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.amberOrange,
                              child: Text(
                                item.name.isNotEmpty ? item.name[0] : '?',
                                style: TextStyle(color: AppColors.safetyBlue),
                              ),
                            ),
                            SizedBox(width: AppSize.s),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: AppTextStyling.title_16M.copyWith(
                                      color: AppColors.black,
                                    ),
                                  ),
                                  SizedBox(height: AppSize.xsH),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        size: 14,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: AppSize.s),
                                      Expanded(
                                        child: Text(
                                          item.location,
                                          style: AppTextStyling.body_12S
                                              .copyWith(
                                                color: Colors.grey[600],
                                              ),
                                        ),
                                      ),
                                      SizedBox(width: AppSize.s),
                                      Text(
                                        item.timeAgo,
                                        style: AppTextStyling.body_12S.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: AppSize.sH),
                                  // Actions: Call, Message (only)
                                  Row(
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () {},
                                        icon: const Icon(Icons.call, size: 16),
                                        label: Text(
                                          'Call',
                                          style: AppTextStyling.body_12S
                                              .copyWith(
                                                color: AppColors.pureWhite,
                                              ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.safetyBlue,
                                          elevation: 0,
                                        ),
                                      ),
                                      SizedBox(width: AppSize.s),
                                      ElevatedButton.icon(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.message,
                                          size: 16,
                                        ),
                                        label: Text(
                                          'Message',
                                          style: AppTextStyling.body_12S
                                              .copyWith(
                                                color: AppColors.pureWhite,
                                              ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.black,
                                          elevation: 0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
