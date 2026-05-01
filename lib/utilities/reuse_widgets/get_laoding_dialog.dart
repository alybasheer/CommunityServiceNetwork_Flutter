
import 'package:flutter/material.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:fyp_source_code/utilities/reuse_widgets/shimmer_loading.dart';

Future<dynamic> getLoadingDialog(BuildContext context) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: AppColors.white,
        child: Padding(
          padding: EdgeInsets.all(AppSize.l),
          child: AppShimmer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ShimmerBlock.circle(size: 56),
                SizedBox(height: AppSize.m),
                const ShimmerBlock(height: 14, widthFactor: 0.6),
                SizedBox(height: AppSize.sH),
                const ShimmerBlock(height: 12, widthFactor: 0.85),
              ],
            ),
          ),
        ),
      );
    },
  );
}
