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
            SafeArea(
              child: Text(
                'Coordination',
                style: AppTextStyling.title_18M.copyWith(
                  color: AppColors.pureWhite,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Text(
              'Connect with volunteers',
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
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: AppSize.mH),

            // Search Bar for All Volunteers
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.m),
              child: TextField(
                controller: controller.searchController,
                onChanged: controller.updateSearch,
                decoration: InputDecoration(
                  hintText: 'Search volunteers...',
                  hintStyle: AppTextStyling.body_12S.copyWith(
                    color: Colors.grey[500],
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  suffixIcon:
                      controller.searchQuery.value.isNotEmpty
                          ? GestureDetector(
                            onTap: () {
                              controller.searchController.clear();
                              controller.updateSearch('');
                            },
                            child: Icon(Icons.close, color: Colors.grey[600]),
                          )
                          : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: AppColors.safetyBlue,
                      width: 2,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSize.m,
                    vertical: AppSize.sH,
                  ),
                ),
              ),
            ),

            SizedBox(height: AppSize.mH),

            // Volunteers List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final volunteers = controller.volunteersList;
                if (volunteers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: AppSize.mH),
                        Text(
                          controller.searchQuery.value.isNotEmpty
                              ? 'No volunteers found'
                              : 'Loading volunteers...',
                          style: AppTextStyling.body_14M.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => controller.refresh(),
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: AppSize.mH),
                    itemCount: volunteers.length,
                    separatorBuilder: (_, __) => SizedBox(height: AppSize.m),
                    itemBuilder: (context, index) {
                      final volunteer = volunteers[index];
                      final firstLetter =
                          volunteer.username.isNotEmpty
                              ? volunteer.username[0].toUpperCase()
                              : '?';

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSize.m),
                        child: GestureDetector(
                          onTap:
                              () => controller.startNewConversation(volunteer),
                          child: Card(
                            elevation: 2,
                            child: Padding(
                              padding: EdgeInsets.all(AppSize.mH),
                              child: Row(
                                children: [
                                  // Avatar
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundColor: AppColors.steelBlue,
                                    child: Text(
                                      firstLetter,
                                      style: TextStyle(
                                        color: AppColors.pureWhite,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: AppSize.m),
                                  // Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          volunteer.username,
                                          style: AppTextStyling.title_16M
                                              .copyWith(color: AppColors.black),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: AppSize.xsH),
                                        Text(
                                          volunteer.email,
                                          style: AppTextStyling.body_12S
                                              .copyWith(
                                                color: Colors.grey[600],
                                              ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Send icon
                                  GestureDetector(
                                    onTap:
                                        () => controller.startNewConversation(
                                          volunteer,
                                        ),
                                    child: Container(
                                      padding: EdgeInsets.all(AppSize.s),
                                      decoration: BoxDecoration(
                                        color: AppColors.safetyBlue.withOpacity(
                                          0.1,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.send,
                                        color: AppColors.safetyBlue,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
