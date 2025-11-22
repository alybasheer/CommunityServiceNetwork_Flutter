import 'package:flutter/material.dart';

class ContainerDecorations {
  static BoxDecoration get shadowDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8.0),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 2,
        blurRadius: 6,
        offset: const Offset(0, 3), // changes position of shadow
      ),
    ],
  );

  // Variant with customizable parameters
  static BoxDecoration customShadowDecoration({
    Color backgroundColor = Colors.white,
    double borderRadius = 8.0,
    double spreadRadius = 1,
    double blurRadius = 6,
    Color? shadowColor,
    Offset offset = const Offset(0, 3),
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: shadowColor ?? Colors.grey.withOpacity(0.2),
          spreadRadius: spreadRadius,
          blurRadius: blurRadius,
          offset: offset,
        ),
      ],
    );
  }
}
