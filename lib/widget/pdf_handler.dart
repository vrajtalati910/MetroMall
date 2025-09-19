import 'package:flutter/material.dart';
import 'package:tailor_mate/widget/common_button.dart';

Future<void> showPdfOptionsDialog(
  BuildContext context,
  final VoidCallback? onClear,
  final VoidCallback? onshare,
) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text("Print / Clear"),
        content: const Text("Do you want to print or clear the customer data?"),
        actions: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CommonButton(
                    text: "Share",
                    onTap: onshare,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CommonButton(
                    text: "clear",
                    onTap: onClear,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
