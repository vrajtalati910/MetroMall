import 'package:flutter/material.dart';
import 'package:tailor_mate/core/theme/app_color.dart';

class AppCheckboxTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;
  final Color? activeColor;
  final Color? borderColor;

  const AppCheckboxTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    this.textStyle,
    this.activeColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.all(0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: textStyle ?? Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Checkbox(
              value: value,
              activeColor: activeColor ?? AppColors.primary,
              onChanged: (val) {
                if (val != null) onChanged(val);
              },
            ),
          ],
        ),
      ),
    );
  }
}
