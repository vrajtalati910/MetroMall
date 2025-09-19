import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:tailor_mate/core/theme/app_assets.dart';
import 'package:tailor_mate/core/theme/app_color.dart';

class MeasurementCardWidget extends StatelessWidget {
  final String value;
  final String label;
  final VoidCallback? onTapEdit;
  final VoidCallback? onEdit;
  final bool isChecked;
  final bool isCheckedUse;
  final ValueChanged<bool?>? onCheckChanged;

  const MeasurementCardWidget({
    super.key,
    required this.value,
    required this.label,
    this.onTapEdit,
    this.onEdit,
    this.isChecked = false,
    this.isCheckedUse = false,
    this.onCheckChanged,
  });

  @override
  Widget build(BuildContext context) {
    bool isTablet = getValueForScreenType<bool>(
      context: context,
      mobile: false,
      tablet: true,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isCheckedUse)
          Checkbox(
            value: isChecked,
            onChanged: onCheckChanged,
            activeColor: AppColors.primary,
          ),
        Expanded(
          child: GestureDetector(
            onTap: onEdit,
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
                  Text(label),
                  const SizedBox(width: 8),
                  Text(
                    value,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: onTapEdit,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      child: SvgPicture.asset(
                        AppAssets.editIcon,
                        height: isTablet ? 24 : 14,
                        width: isTablet ? 24 : 14,
                        colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
