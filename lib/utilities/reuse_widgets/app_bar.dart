
// import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';
// import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class CAppBar extends StatelessWidget implements PreferredSizeWidget {
//   CAppBar({
//     super.key,
//     this.title,
//     this.actions,
//     this.isLeading,
//     this.isArrow = true,
//     this.onPressed,
//   });
//   String? title;
//   bool isArrow = true;
//   List<Widget>? actions;
//   IconData? isLeading;
//   VoidCallback? onPressed;

//   @override
//   // TODO: implement preferredSize
//   Size get preferredSize => Size.fromHeight(60);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: AppSize.s),
//       child: AppBar(
//         // title: Text(title!, style: AppTextStyling.titleMedium),
//         title: Text(title!,style: AppTextStyling.titleMedium,),
//         automaticallyImplyLeading: false,
//         leading:
//             isArrow
//                 ? IconButton(
//                   onPressed: () {
//                     onPressed;
//                   },
//                   icon: Icon(Icons.arrow_back_ios),
//                 )
//                 : IconButton(
//                   onPressed: () {
//                     Get.back();
//                   },
//                   icon: Icon(isLeading),
//                 ),
//         actions: actions,
//       ),
//     );
//   }
// }
