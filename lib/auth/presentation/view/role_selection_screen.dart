import 'package:flutter/material.dart';
import 'package:fyp_source_code/auth/presentation/controller/auth_contrl.dart';
import 'package:fyp_source_code/auth/presentation/controller/role_selection_controller.dart';
import 'package:fyp_source_code/auth/presentation/view/widgets/role_card.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/storage_helper.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:get/get.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCntrl =
        Get.find<
          AuthController
        >(); // auth controller find karna ha<> representing type , () will create instance of it when find
    final roleCntrl = Get.find<RoleSelectionController>();
    final currentRole = StorageHelper().readData('role');
    final isAdmin = currentRole == 'admin';
    final isVolunteer = currentRole == 'volunteer';
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSize.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSize.xxxlHeight,
              Text('I want to...', style: AppTextStyling.title_30M),
              AppSize.sHeight,
              Text(
                'Choose how you\'d like to help your community',
                style: AppTextStyling.body_12S,
              ),
              AppSize.xxxlHeight,
              // Request Help Card
              roleCard(
                'requestHelp',
                Icons.favorite,
                Colors.orange[700]!,
                'Request Help',
                'Submit a request for assistance\nfrom volunteers in your area',
              ),
              AppSize.lHeight,

              // Volunteer Card (Primary)
              roleCard(
                'volunteer',
                Icons.handshake,
                Colors.blue[700]!,
                isVolunteer ? 'Volunteer Dashboard' : 'Verify as Volunteer',
                isVolunteer
                    ? 'Browse and respond to\nhelp requests in your area'
                    : 'Submit your verification\nrequest to become a volunteer',
              ),
              if (isAdmin) ...[
                AppSize.lHeight,
                roleCard(
                  'admin',
                  Icons.security,
                  Colors.green[700]!,
                  'Admin Access',
                  'Monitor and manage community\nresponse activities',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
