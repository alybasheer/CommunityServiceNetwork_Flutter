// Helper widgets for ProfileScreen
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:fyp_source_code/volunteer_side/profile/presentation/controller/profile_controller.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProfileController>();
    final name = ctrl.nameController.text.trim();
    final email = ctrl.emailController.text.trim();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(AppSize.m),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: const Color.fromRGBO(97, 97, 97, 0.2),
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'V',
                style: AppTextStyling.title_18M,
              ),
            ),
            SizedBox(width: AppSize.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name.isNotEmpty ? name : 'Volunteer User', style: AppTextStyling.title_18M),
                  SizedBox(height: AppSize.xsH),
                  Text(email.isNotEmpty ? email : 'user@example.com', style: AppTextStyling.body_12S),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AccountTile extends StatelessWidget {
  const AccountTile({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProfileController>();
    return ExpansionTile(
      leading: const Icon(Icons.person_rounded),
      title: Text('Account', style: AppTextStyling.title_16M),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.m, vertical: AppSize.sH),
          child: Column(
            children: [
              TextField(
                controller: ctrl.nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: AppSize.sH),
              TextField(
                controller: ctrl.emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: AppSize.sH),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: ctrl.saveProfile,
                    child: const Text('Save'),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

class AppearanceTile extends StatelessWidget {
  const AppearanceTile({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProfileController>();
    return Obx(
      () => ExpansionTile(
        leading: const Icon(Icons.dark_mode_rounded),
        title: Text('Appearance', style: AppTextStyling.title_16M),
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: ctrl.isSwitching.value,
            onChanged:(newValue) =>  ctrl.onSwitch(),
          )
        ],
      ),
    );
  }
}

class PolicyTile extends StatelessWidget {
  const PolicyTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: const Icon(Icons.policy_rounded),
      title: Text('Policy', style: AppTextStyling.title_16M),
      children: [
        ListTile(
          title: const Text('Privacy Policy'),
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Privacy Policy'),
                content: const SingleChildScrollView(
                  child: Text('This is a placeholder privacy policy. Replace with real policy.'),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  )
                ],
              ),
            );
          },
        )
      ],
    );
  }
}

class SignOutTile extends StatelessWidget {
  const SignOutTile({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProfileController>();
    return ExpansionTile(
      leading: const Icon(Icons.exit_to_app_rounded),
      title: Text('Sign Out', style: AppTextStyling.title_16M),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.m),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.emergencyRed),
            onPressed: ctrl.signOut,
            child: const Text('Sign out'),
          ),
        )
      ],
    );
  }
}
