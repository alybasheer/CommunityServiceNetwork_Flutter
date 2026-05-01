import 'package:flutter/material.dart';
import 'package:fyp_source_code/auth/presentation/view/widgets/role_card.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                'request_help',
                Icons.favorite,
                Colors.orange[700]!,
                'Request Help',
                'Submit a request for assistance\nfrom volunteers in your area',
              ),
              AppSize.lHeight,
              AppSize.lHeight,

              // Volunteer Card (Primary)
              roleCard(
                'volunteer',
                Icons.handshake,
                Colors.blue[700]!,
                'Verify as Volunteer',
                'Browse and respond to\nhelp requests in your area',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
