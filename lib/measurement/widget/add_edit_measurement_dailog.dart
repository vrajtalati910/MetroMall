import 'package:flutter/material.dart';
import 'package:tailor_mate/core/theme/app_color.dart';
import 'package:tailor_mate/widget/app_text_form_field.dart';
import 'package:tailor_mate/widget/common_button.dart';

class MeasurementDialog extends StatefulWidget {
  final String? initialValue;
  final String title;
  // final String hintText;
  final ValueChanged<String> onSave;

  const MeasurementDialog({
    super.key,
    this.initialValue,
    required this.title,
    // this.hintText = "Enter measurement name",
    required this.onSave,
  });

  @override
  State<MeasurementDialog> createState() => _MeasurementDialogState();
}

class _MeasurementDialogState extends State<MeasurementDialog> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? "");
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(widget.title),
      content: AppTextFormField(
        controller: _controller,
        // label: widget.hintText,
        focusNode: _focusNode,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      actions: [
        Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CommonButton(
                  backgroundColor: AppColors.background,
                  text: "Cancel",
                  textColor: AppColors.primary,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CommonButton(
                  text: "Save",
                  onTap: () {
                    String value = _controller.text.trim();
                    if (value.isNotEmpty) {
                      widget.onSave(value);
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        // TextButton(
        //   onPressed: () => Navigator.pop(context),
        //   child: const Text("Cancel"),
        // ),
        // CommonButton(
        //   text: "Save",
        //   onTap: () {
        //     String value = _controller.text.trim();
        //     if (value.isNotEmpty) {
        //       widget.onSave(value);
        //       Navigator.pop(context);
        //     }
        //   },
        // ),
      ],
    );
  }
}
