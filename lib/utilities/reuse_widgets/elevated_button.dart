import 'package:flutter/material.dart';
class RoundButton extends StatelessWidget {
  final bool loading;  // ✅ Instance variable
  final VoidCallback onpressed;
  final double height, width;
  final Color color;
  final String title;
  double? radius; // Default radius for the button
  TextStyle? textStyle; // Optional text style for the button



   RoundButton({
    super.key,
    required this.onpressed,
    required this.title,
    required this.height,
    required this.width,
    this.color = Colors.purple,
    this.loading = false,
    this.radius = 8.0,  // ✅ Allow passing radius
    
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onpressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius!),
        ),
        backgroundColor: color,
      ),
      child: loading
          ? Center(child: CircularProgressIndicator())
          : Text(
        title,style: textStyle,
      ),
    );
  }
}
