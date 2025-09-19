import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:tailor_mate/core/theme/app_assets.dart';
import 'package:tailor_mate/core/theme/app_color.dart';

class DashboardCardWidget extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  final VoidCallback? onTap;

  const DashboardCardWidget({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isTablet = getValueForScreenType<bool>(
      context: context,
      mobile: false,
      tablet: true,
    );

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Image.asset(
              icon,
              height: isTablet ? 32 : 20,
              width: isTablet ? 32 : 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            SvgPicture.asset(
              AppAssets.rightArrowIcon,
              height: isTablet ? 24 : 17,
              width: isTablet ? 24 : 17,
              colorFilter: ColorFilter.mode(AppColors.grey, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}
