import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyling {
  static TextStyle get title_30M => TextStyle(
    fontFamily: 'Poppins',
    fontSize: 30.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    overflow: TextOverflow.ellipsis,
  );

  static TextStyle get title_22L => TextStyle(
    fontFamily: 'Poppins',
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    overflow: TextOverflow.ellipsis,
  );

  static TextStyle get title_18M => TextStyle(
    fontFamily: 'Poppins',
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    overflow: TextOverflow.ellipsis,
  );

  static TextStyle get title_16M => TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    overflow: TextOverflow.ellipsis,
  );

  static TextStyle get body_16M => TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    overflow: TextOverflow.ellipsis,
  );

  static TextStyle get body_14M => TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    overflow: TextOverflow.ellipsis,
  );

  static TextStyle get body_12S => TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    overflow: TextOverflow.ellipsis,
  );
}
