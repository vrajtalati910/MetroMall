import 'package:flutter/material.dart';
import 'package:tailor_mate/core/theme/app_assets.dart';
import 'package:tailor_mate/core/theme/app_color.dart';
import 'package:tailor_mate/widget/app_svg_image.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({
    super.key,
    this.onBackTap,
    this.title,
    this.titleWidget,
    this.actions,
    this.elivation,
    this.titleSpacing,
    this.leadingWidget,
    this.leadingWidth,
    this.centerTitle = false,
    this.isLeading = true,
  });
  final VoidCallback? onBackTap;
  final String? title;
  final Widget? titleWidget;
  final Widget? leadingWidget;
  final List<Widget>? actions;
  final double? elivation;
  final double? titleSpacing;
  final double? leadingWidth;
  final bool centerTitle;
  final bool isLeading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      automaticallyImplyLeading: false,

      leading: isLeading
          ? onBackTap != null
              ? IconButton(
                  splashRadius: 24,
                  onPressed: onBackTap,
                  icon: const AppSvgImage(
                    AppAssets.leftArrowIcon,
                    height: 20,
                    width: 20,
                    color: AppColors.white,
                  ))
              : leadingWidget
          : null,
      centerTitle: centerTitle,
      // leadingWidth: onBackTap != null ? null : leadingWidth,
      titleSpacing: titleSpacing ?? 24,
      title: title != null
          ? Text(
              title!,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                    color: AppColors.white,
                  ),
            )
          : titleWidget,
      actions: actions,
      elevation: elivation ?? 0,
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
