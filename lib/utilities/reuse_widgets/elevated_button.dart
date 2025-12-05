import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onpressed;
  final double height, width;
  final Color color;
  final String title;
  final double? radius;
  final TextStyle? textStyle;

  const RoundButton({
    super.key,
    required this.onpressed,
    required this.title,
    required this.height,
    required this.width,
    this.color = Colors.purple,
    this.loading = false,
    this.radius = 8.0,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onpressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 8.0),
        ),
        backgroundColor: color,
      ),
      child:
          loading
              ? const Center(child: CircularProgressIndicator())
              : Text(title, style: textStyle),
    );
  }
}
