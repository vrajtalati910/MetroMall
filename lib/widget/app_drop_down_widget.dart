import 'package:flutter/material.dart';
import 'package:tailor_mate/core/theme/app_assets.dart';
import 'package:tailor_mate/core/theme/app_color.dart';
import 'package:tailor_mate/widget/app_svg_image.dart';

class AppDropDown<T> extends StatelessWidget {
  const AppDropDown(
      {super.key,
      required this.onSelect,
      this.validator,
      this.selectedValue,
      this.hintText,
      this.number,
      this.focusNode,
      required this.items});
  final Function(T? value) onSelect;
  final String? Function(T?)? validator;

  final T? selectedValue;
  final String? hintText;
  final int? number;
  final FocusNode? focusNode;
  final List<DropdownMenuItem<T>>? items;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      borderRadius: BorderRadius.circular(8),
      initialValue: selectedValue,
      validator: validator,
      focusNode: focusNode,
      icon: const AppSvgImage(AppAssets.downArrowIcon),
      onChanged: (v) {
        onSelect(v);
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
        fillColor: AppColors.white,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.disabledBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.disabledBorder,
          ),
        ),
      ),
      items: items,
    );
  }
}
