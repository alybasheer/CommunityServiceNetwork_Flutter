import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/container_decoration.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
import 'package:fyp_source_code/volunteer_side/home/presentation/view/widgets/request_details_dialog.dart';

Widget requestCard(
    int index, {
     required ImageProvider requestImage,
     required String title,
     required String description,
     required String location,
     VoidCallback? onAccept,
    }) {
 return Container(
  decoration: ContainerDecorations.customShadowDecoration(
   backgroundColor: AppColors.pureWhite,
   borderRadius:12,
   shadowColor: AppColors.darkGray.withOpacity(0.1),
   blurRadius:8,
   spreadRadius:0,
  ),
  child: Material(
   color: Colors.transparent,
   child: InkWell(
    onTap: () {
     Get.dialog(
      RequestDetailsDialog(
       image: requestImage,
       title: title,
       description: description,
       location: location,
       onAccept: onAccept,
      ),
      barrierColor: AppColors.darkGray.withOpacity(0.4),
     );
    },
    borderRadius: BorderRadius.circular(12),
    child: Padding(
     padding: EdgeInsets.all(AppSize.mH),
     child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Row(
        children: [
         Container(
          decoration: BoxDecoration(
           shape: BoxShape.circle,
           gradient: LinearGradient(
            colors: [AppColors.steelBlue, AppColors.safetyBlue],
           ),
          ),
          padding: EdgeInsets.all(2),
          child: CircleAvatar(
           radius:28,
           backgroundColor: AppColors.steelBlue.withOpacity(0.1),
           child: Icon(
            Icons.person_2_rounded,
            color: AppColors.steelBlue,
            size:32,
           ),
          ),
         ),
         SizedBox(width: AppSize.m),
         Expanded(
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            Text(
             title,
             style: AppTextStyling.title_16M.copyWith(
              color: AppColors.darkGray,
              fontWeight: FontWeight.w600,
             ),
            ),
            SizedBox(height: AppSize.xsH),
            Container(
             decoration: BoxDecoration(
              color: AppColors.amberOrange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
             ),
             padding: EdgeInsets.symmetric(
              horizontal: AppSize.s,
              vertical:2,
             ),
             child: Text(
              'Urgent',
              style: AppTextStyling.body_12S.copyWith(
               color: AppColors.amberOrange,
               fontWeight: FontWeight.w600,
              ),
             ),
            ),
           ],
          ),
         ),
         Icon(
          Icons.arrow_forward_ios,
          size:16,
          color: AppColors.mediumGray,
         ),
        ],
       ),
       SizedBox(height: AppSize.mH),
       Text(
        description,
        maxLines:2,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyling.body_14M.copyWith(
         color: AppColors.darkGray,
         height:1.4,
        ),
       ),
       SizedBox(height: AppSize.mH),
       Row(
        children: [
         Icon(
          Icons.location_on_outlined,
          size:16,
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
       SizedBox(height: AppSize.mH),
       Row(
        children: [
         Expanded(
          child: OutlinedButton.icon(
           onPressed: () {},
           icon: const Icon(Icons.phone),
           label: const Text('Call'),
           style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.steelBlue,
            side: BorderSide(
             color: AppColors.steelBlue.withOpacity(0.5),
            ),
            shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(8),
            ),
           ),
          ),
         ),
         SizedBox(width: AppSize.s),
         Expanded(
          child: ElevatedButton.icon(
           onPressed: onAccept,
           icon: const Icon(Icons.check_circle),
           label: const Text('Accept'),
           style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.reliefGreen,
            shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(8),
            ),
           ),
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
