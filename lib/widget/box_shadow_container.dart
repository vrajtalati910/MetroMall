import 'package:flutter/material.dart';
import 'package:tailor_mate/core/theme/app_color.dart';
import 'package:tailor_mate/core/utils/extentions/colors_extnetions.dart';

class BoxShadowContainerWidget extends StatelessWidget {
  const BoxShadowContainerWidget({super.key, required this.child, this.margin, this.radius, this.padding});
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final double? radius;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin ?? const EdgeInsets.fromLTRB(24, 0, 24, 0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(radius ?? 16),
        boxShadow: [
          BoxShadow(
            color: AppColors.boxShadow.withOpacity2(0.015),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: child,
    );
  }
}
