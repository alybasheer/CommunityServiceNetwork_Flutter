import 'package:flutter/material.dart';
import 'package:fyp_source_code/auth/presentation/controller/role_selection_controller.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:get/get.dart';

final roleCntrl = Get.find<RoleSelectionController>();

Widget roleCard( String role, IconData icon, Color iconColor,String title, String description) {
    return GestureDetector(
              onTap: () {
                roleCntrl.selectRole(role);
                roleCntrl.navigateBasedOnRole();
              },
              child: Container(
                padding: EdgeInsets.all(AppSize.l),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.lightBorderGray),
                  borderRadius: BorderRadius.circular(AppSize.l),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(AppSize.m),
                      decoration: BoxDecoration(
                        color: Color(0xFFE8F5E9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: iconColor,
                        size: 24,
                      ),
                    ),
                    AppSize.mWidth,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTextStyling.title_16M,
                          ),
                          AppSize.xsHeight,
                          Text(
                            description,
                            style: AppTextStyling.body_12S,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
  }