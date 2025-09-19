import 'package:flutter/material.dart';
import 'package:tailor_mate/core/theme/app_color.dart';

class FloatingActionWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;

  const FloatingActionWidget({
    super.key,
    this.onPressed,
    this.icon = Icons.add, // default icon
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      backgroundColor: AppColors.primary,
      child: Icon(
        Icons.add,
        color: iconColor ?? Colors.white,
      ),
    );
  }
}
