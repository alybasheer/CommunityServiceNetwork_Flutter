import 'package:flutter/material.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_text.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';

class RequestDropdownField extends StatelessWidget {
  final String hint;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;

  const RequestDropdownField({
    super.key,
    required this.hint,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final fieldColor = theme.inputDecorationTheme.fillColor ?? scheme.surface;
    final hintColor = scheme.onSurfaceVariant;
    final menuColor = scheme.brightness == Brightness.dark
        ? const Color(0xFF111827)
        : scheme.surface;
    final textStyle = AppTextStyling.body_14M.copyWith(
      color: scheme.onSurface,
    );
    final effectiveValue = items.contains(value) ? value : null;

    return DropdownButtonFormField<String>(
      value: effectiveValue,
      isExpanded: true,
      dropdownColor: menuColor,
      iconEnabledColor: scheme.onSurface,
      iconDisabledColor: hintColor,
      style: textStyle,
      hint: Text(
        hint,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyling.body_14M.copyWith(color: hintColor),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: fieldColor,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSize.s,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 1.4),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.dividerColor),
        ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textStyle,
              ),
            ),
          )
          .toList(),
      onChanged: items.isEmpty ? null : onChanged,
    );
  }
}
