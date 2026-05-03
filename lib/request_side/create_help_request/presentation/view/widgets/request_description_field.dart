import 'package:flutter/material.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';

class RequestDescriptionField extends StatelessWidget {
  final TextEditingController controller;

  const RequestDescriptionField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(AppSize.s),
      decoration: BoxDecoration(
        color: theme.inputDecorationTheme.fillColor ?? scheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: TextField(
        controller: controller,
        minLines: 4,
        maxLines: 6,
        style: AppTextStyling.body_14M.copyWith(
          color: scheme.onSurface,
        ),
        decoration: InputDecoration(
          hintText: 'Describe your situation... ',
          hintStyle: AppTextStyling.body_14M.copyWith(
            color: scheme.onSurfaceVariant,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
