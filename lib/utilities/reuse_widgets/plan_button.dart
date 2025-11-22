import 'package:flutter/material.dart';

Widget buildPlanButton({
  required String label,
  required Color backgroundColor,
  required double height,
  required double width,
  double borderRadius = 8.0,
  required Color textColor,
  TextStyle? textStyle,
}) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    child: Center(child: Text(label, style: textStyle)),
  );
}
