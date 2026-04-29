import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_source_code/request_side/home/presentation/controller/request_home_controller.dart';
import 'package:fyp_source_code/request_side/home/presentation/view/widgets/request_help_fab.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';

class RequestHomeScreen extends StatelessWidget {
  const RequestHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RequestHomeController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        title: Text(
          'Request Home',
          style: AppTextStyling.title_18M.copyWith(
            color: AppColors.darkGray,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSize.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need help fast?',
              style: AppTextStyling.title_18M.copyWith(
                color: AppColors.darkGray,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: AppSize.xsH),
            Text(
              'Tap the button below to send a request to nearby volunteers.',
              style: AppTextStyling.body_14M.copyWith(
                color: AppColors.mediumGray,
              ),
            ),
            SizedBox(height: AppSize.lH),
            Container(
              padding: EdgeInsets.all(AppSize.m),
              decoration: BoxDecoration(
                color: AppColors.pureWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.lightBorderGray),
              ),
              child: Row(
                children: [
                  Icon(Icons.support_agent, color: AppColors.steelBlue),
                  SizedBox(width: AppSize.s),
                  Expanded(
                    child: Text(
                      'Your request will be matched with helpers in real time.',
                      style: AppTextStyling.body_14M.copyWith(
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: RequestHelpFab(
        onPressed: controller.openRequestHelpSheet,
      ),
    );
  }
}
