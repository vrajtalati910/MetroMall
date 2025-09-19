// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:tailor_mate/core/theme/app_color.dart';

class AppTextFormField extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const AppTextFormField({
    required this.controller,
    this.focusNode,
    this.hintText,
    this.enabled,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.textInputAction,
    this.contentPadding,
    this.label,
    this.keyboardType,
    this.onTap,
    this.height,
    this.textStyle,
    this.onChanged,
  });
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? hintText;
  final bool? enabled;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obscureText;
  final bool readOnly;
  final int maxLines;
  final int? minLines;
  final TextInputAction? textInputAction;
  final EdgeInsetsGeometry? contentPadding;
  final String? label;
  final TextInputType? keyboardType;
  final void Function()? onTap;
  final double? height;
  final TextStyle? textStyle;
  final void Function(String)? onChanged;

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  late FocusNode _focusNode;
  bool isFocused = false;

  @override
  void initState() {
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      if (mounted)
        setState(() {
          isFocused = _focusNode.hasFocus;
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        height: widget.height,
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: isFocused ? AppColors.primaryBlack : AppColors.disabledBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextFormField(
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          clipBehavior: Clip.hardEdge,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          focusNode: _focusNode,
          enabled: widget.enabled,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          cursorColor: AppColors.primaryBlack,
          style: widget.textStyle ?? Theme.of(context).textTheme.bodyMedium,
          readOnly: widget.readOnly,
          validator: widget.validator,
          obscureText: widget.obscureText,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          textInputAction: widget.textInputAction,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: widget.label,
            labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grey),
            hintText: widget.hintText,
            suffixIcon: widget.suffixIcon,
            prefixIcon: widget.prefixIcon,
            contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          ),
        ),
      ),
    );
  }
}
