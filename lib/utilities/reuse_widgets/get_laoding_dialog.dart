
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';

Future<dynamic> getLoadingDialog(BuildContext context) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: AppColors.white,
        child: Container(
          height: AppSize.sectionMedium,
          width: 50,
          alignment: Alignment.center,
          child: CupertinoActivityIndicator(
            color: AppColors.safetyBlue,
            radius: AppSize.xxl,
          ),
        ),
      );
    },
  );
}
