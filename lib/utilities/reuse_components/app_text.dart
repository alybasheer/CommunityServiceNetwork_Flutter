import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyling {
  static TextStyle title_30M = TextStyle(
    
    fontFamily: 'Barlow',
    fontSize: 30.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    overflow: TextOverflow.ellipsis,
  );
  static TextStyle title_22L = TextStyle(
    fontFamily: 'Barlow',
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    overflow: TextOverflow.ellipsis
    
  );
  static TextStyle title_18M = TextStyle(
    fontFamily: 'Barlow',
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    overflow: TextOverflow.ellipsis
  );
  static TextStyle title_16M = TextStyle(
    
    fontFamily: 'Barlow',
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    overflow:  TextOverflow.ellipsis
  );
  static TextStyle body_16M = TextStyle(
    fontFamily: 'Barlow',
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    overflow: TextOverflow.ellipsis,
  );
  static TextStyle body_14M = TextStyle(
    fontFamily: 'Barlow',
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,

    overflow: TextOverflow.ellipsis,
  );
  static TextStyle body_12S = TextStyle(
    fontFamily: 'Barlow',
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: Color(0xff000000),
    overflow: TextOverflow.ellipsis,
  );
  // static TextStyle caption = TextStyle(
  //   fontFamily: 'Barlow',
  //   fontSize: 16.sp,
  //   fontWeight: FontWeight.w400,
  //   overflow: TextOverflow.ellipsis,
  // );
  // static TextStyle button = TextStyle(
  //   fontFamily: 'Barlow',
  //   fontSize: 16.sp,
  //   fontWeight: FontWeight.w600,
  //   color: Colors.white,
  //   letterSpacing: 0.5,
  //   overflow: TextOverflow.ellipsis,
  // );

  // // 🔹 Ellipsis version (truncated body text)
  // static TextStyle bodyMediumEllipsis = TextStyle(
  //   fontFamily: 'Barlow',
  //   fontSize: 14.sp,
  //   fontWeight: FontWeight.w500,
  //   color: Color(0xff000000),
  //   overflow: TextOverflow.ellipsis,
  // );
}
