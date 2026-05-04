import 'package:flutter/material.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final Text? hintText;
  final String? underText;
  final TextInputType? keyboardType;
  final bool hiddenText;
  final String? Function(String?)? val;
  final void Function(String)? onChange; // Make onChange optional
  final TextEditingController textControl;
  final int? maxLines;
  final Color? col;
  final bool? enabled;
  final Widget? leadingIcon;
  final Widget? suffixIcon;
  final InputBorder? borderType;
  final double? fieldHeight;
  final InputBorder? focusBorder;

  const CustomTextField({
    super.key,
    this.hintText,
    this.keyboardType,
    this.onChange,
    this.underText,
    this.hiddenText = false,
    this.val,
    required this.textControl,
    this.maxLines,
    this.col,
    this.enabled,
    this.leadingIcon,
    this.borderType,
    this.fieldHeight,
    this.suffixIcon,
    this.focusBorder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return TextFormField(
      validator: val,
      textAlign: TextAlign.start,
      keyboardType: keyboardType,
      onChanged: onChange,
      obscureText:
          hiddenText, // This will only be called if onChange is provided
      controller: textControl,
      maxLines: hiddenText ? 1 : maxLines,
      enabled: enabled,
      style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurface),

      decoration: InputDecoration(
        hintText: hintText?.data,
        hintStyle: hintText?.style ?? theme.inputDecorationTheme.hintStyle,
        enabledBorder:
            borderType ??
            UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.silverGrey),
            ),
        focusedBorder:
            focusBorder ??
            UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.silverGrey),
            ),
        helperText: underText,
        fillColor: col ?? theme.inputDecorationTheme.fillColor,
        filled: col != null || theme.inputDecorationTheme.filled == true,
        prefix: leadingIcon,
        contentPadding:
            fieldHeight != null
                ? EdgeInsets.symmetric(horizontal: fieldHeight!)
                : null,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
