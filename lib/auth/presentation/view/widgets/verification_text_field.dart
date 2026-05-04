import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';

class VerificationTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final int maxLines;
  final IconData? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;

  const VerificationTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.prefixIcon,
    this.inputFormatters,
  });

  @override
  State<VerificationTextField> createState() => _VerificationTextFieldState();
}

class _VerificationTextFieldState extends State<VerificationTextField> {
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyling.body_12S.copyWith(
            color: scheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        AppSize.mHeight,
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          inputFormatters: widget.inputFormatters ?? [],
          validator: (val) {
            final error = widget.validator?.call(val);
            setState(() => _errorMessage = error);
            return error;
          },
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTextStyling.body_12S.copyWith(
              color: scheme.onSurfaceVariant,
            ),
            filled: true,
            fillColor: theme.inputDecorationTheme.fillColor ?? scheme.surface,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.lightBorderGray),
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.lightBorderGray),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.safetyBlue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.emergencyRed, width: 1),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSize.m,
              vertical: AppSize.m,
            ),
            prefixIcon:
                widget.prefixIcon != null
                    ? Icon(widget.prefixIcon, color: AppColors.steelBlue)
                    : null,
          ),
          style: AppTextStyling.body_12S.copyWith(color: scheme.onSurface),
        ),
        if (_errorMessage != null && _errorMessage!.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: AppSize.s),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: AppColors.emergencyRed,
                  size: 16,
                ),
                AppSize.sWidth,
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: AppColors.emergencyRed,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        AppSize.lHeight,
      ],
    );
  }
}
