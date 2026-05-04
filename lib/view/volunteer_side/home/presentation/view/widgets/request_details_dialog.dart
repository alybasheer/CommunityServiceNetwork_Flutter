import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/container_decoration.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';

class RequestDetailsDialog extends StatelessWidget {
  final ImageProvider image;
  final String title;
  final String description;
  final String location;
  final bool isAccepting;
  final VoidCallback? onAccept;

  const RequestDetailsDialog({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.location,
    this.isAccepting = false,
    this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: AppSize.sectionXLarge * 2,
        margin: EdgeInsets.all(AppSize.mH),
        decoration: ContainerDecorations.customShadowDecoration(
          backgroundColor: AppColors.pureWhite,
          borderRadius: 16,
          shadowColor: AppColors.darkGray.withOpacity(0.15),
          blurRadius: 12,
          spreadRadius: 0,
        ),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.all(AppSize.mH),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.steelBlue.withOpacity(0.25),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image(
                      image: image,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: AppSize.mH),
                Text(
                  title,
                  style: AppTextStyling.title_16M.copyWith(
                    color: AppColors.darkGray,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSize.sH),
                Text(
                  description,
                  style: AppTextStyling.body_14M.copyWith(
                    color: AppColors.darkGray,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: AppSize.mH),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: AppColors.darkGray,
                    ),
                    SizedBox(width: AppSize.s),
                    Expanded(
                      child: Text(
                        location,
                        style: AppTextStyling.body_12S.copyWith(
                          color: AppColors.darkGray,
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                SizedBox(height: AppSize.mH),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.steelBlue,
                          side: BorderSide(
                            color: AppColors.steelBlue.withOpacity(0.5),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: AppSize.s),
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            isAccepting
                                ? null
                                : () {
                                  Get.back();
                                  onAccept?.call();
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.reliefGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(isAccepting ? 'Accepting' : 'Accept'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
