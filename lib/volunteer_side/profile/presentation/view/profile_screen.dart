// New profile screen for volunteer_side
// ...existing code...
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:fyp_source_code/volunteer_side/profile/presentation/controller/profile_controller.dart';
import 'package:fyp_source_code/volunteer_side/profile/presentation/view/widgets/profile_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.safetyBlue,
        title: Text('Profile', style: AppTextStyling.title_18M.copyWith(color: AppColors.pureWhite)),
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSize.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ProfileHeader(),
            SizedBox(height: AppSize.mH),
            Expanded(
              child: ListView(
                children: const [
                  AccountTile(),
                  AppearanceTile(),
                  PolicyTile(),
                  SignOutTile(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
