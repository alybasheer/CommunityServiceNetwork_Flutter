import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centralized design system for responsive sizing.
/// Uses:
/// - .h / .w → for small, touch-safe spacings and paddings
/// - .sh / .sw → for layout-level sections and proportions
/// Recommended to call `ScreenUtilInit` in main.dart first.
class AppSize {
  // ==============================
  // 🔹 SMALL SPACING (fixed scale)
  // ==============================

  // Horizontal spacing (width-based)
  static double get xs => 8.w; // icon gaps / micro spacing
  static double get s => 12.w; // small padding
  static double get m => 16.w; // container padding
  static double get l => 24.w; // card internal spacing
  static double get xl => 32.w;
  static double get xxl => 38.w;
  
   // major section padding

  // Vertical spacing (height-based)
  static double get xsH => 8.h; // tight vertical spacing
  static double get sH => 12.h; // small vertical gap
  static double get mH => 16.h; // medium between text/buttons
  static double get lH => 24.h; // sections separation
  static double get xlH => 32.h;
  
  static double get xxlH => 38.h; 
  static double get xxxlH => 44.h;// large section gaps

  // ==============================
  // 🔹 LAYOUT-LEVEL SIZES (proportionate)
  // ==============================
  static double get sectionxs => 0.5.sh;
  static double get sectionSmall => 0.10.sh;  // small layout section
  static double get sectionMedium => 0.18.sh; // typical header / panel
  static double get sectionLarge => 0.25.sh;  // hero or chart block
  static double get sectionXLarge => 0.35.sh; // full-page header/banner

  // Horizontal layout sections
  static double get containerSmall => 0.35.sw;
  static double get containerMedium => 0.5.sw;
  static double get containerLarge => 0.8.sw;

  // ==============================
  // 🔹 COMPONENT DIMENSIONS
  // ==============================

  static double get buttonHeight => 52.h;
  static double get inputHeight => 48.h;
  static double get iconSize => 24.w;
  static double get cardRadius => 16.r;
  static double get cardElevation => 4;

  // ==============================
  // 🔹 COMMON GAPS (Widgets)
  // ==============================

  static Widget get xsHeight => SizedBox(height: xsH);
  static Widget get sHeight => SizedBox(height: sH);
  static Widget get mHeight => SizedBox(height: mH);
  static Widget get lHeight => SizedBox(height: lH);
  static Widget get xlHeight => SizedBox(height: xlH);
  static Widget get xxlHeight => SizedBox(height: xxlH);
  static Widget get xxxlHeight => SizedBox(height: xxxlH);

  static Widget get xsWidth => SizedBox(width: xs);
  static Widget get sWidth => SizedBox(width: s);
  static Widget get mWidth => SizedBox(width: m);
  static Widget get lWidth => SizedBox(width: l);
  static Widget get xlWidth => SizedBox(width: xl);
  static Widget get xxlWidth => SizedBox(width: xxl);


  // ==============================
  // 🔹 CUSTOM PERCENTAGE HELPERS
  // ==============================
  static double wp(double percent) =>
      ScreenUtil().screenWidth * (percent / 100);
  static double hp(double percent) =>
      ScreenUtil().screenHeight * (percent / 100);
}
