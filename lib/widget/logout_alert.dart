import 'package:flutter/material.dart';
import 'package:tailor_mate/core/local_storage/i_local_storage_repository.dart';
import 'package:tailor_mate/core/theme/app_color.dart';
import 'package:tailor_mate/core/utils/utility.dart';
import 'package:tailor_mate/login/view/login_page.dart';
import 'package:tailor_mate/widget/common_button.dart';

Future<void> showLogoutDialog(BuildContext context, ILocalStorageRepository localStorage) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap a button
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CommonButton(
                    backgroundColor: AppColors.background,
                    text: "Cancel",
                    textColor: AppColors.primary,
                    onTap: () {
                      Navigator.pop(context); // close dialog
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CommonButton(
                    text: "Logout",
                    onTap: () async {
                      Navigator.pop(context); // close dialog first
                      final isCleared = await localStorage.clearAuth();
                      if (isCleared) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                            (_) => false);
                      } else {
                        Utility.toast(message: "Logout failed");
                      }
                    },
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
