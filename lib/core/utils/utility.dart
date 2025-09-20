import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:tailor_mate/core/constant/app_string.dart';
import 'package:tailor_mate/core/theme/app_color.dart';
import 'package:tailor_mate/core/utils/extentions/string_extentions.dart';

class Utility {
  // Flutter toast
  static void toast({required String? message, Color? color}) {
    if (message != null) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: message, backgroundColor: color ?? AppColors.inputField, textColor: AppColors.black);
    }
  }

  static Widget noDataWidget({required BuildContext context, required String text}) {
    return Center(
      child: Text(
        text.inCaps,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  static bool isSmallDevice(
    BuildContext context, {
    double maxWidth = 360,
    double maxHeight = 640,
  }) {
    final size = MediaQuery.of(context).size;
    return size.width <= maxWidth || size.height <= maxHeight;
  }

  // Email validation
  static bool isValidEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // No value = no error
    }

    const pattern = r'^(https?:\/\/)?([\w\-]+\.)+[\w\-]+(\/[\w\-./?%&=]*)?$';
    final regex = RegExp(pattern);

    if (!regex.hasMatch(value.trim())) {
      return 'Please enter a valid URL';
    }

    return null; // Valid URL
  }

  static String formmtedDate(DateTime date, BuildContext context) {
    final currentDate = DateTime.now();
    final yesterDate = DateTime.now().subtract(const Duration(days: 1));
    if (currentDate.year == date.year && currentDate.month == date.month && currentDate.day == date.day) {
      return 'Today';
    }
    if (yesterDate.year == date.year && yesterDate.month == date.month && (yesterDate.day) == date.day) {
      return 'Yesterday';
    }
    return DateFormat('MMM dd, yyyy').format(date);
  }

  // Image loader
  static Widget imageLoader(
      {required String url,
      required String placeholder,
      double? height,
      double? width,
      BoxFit? fit,
      BuildContext? context,
      bool isShapeCircular = false,
      BorderRadius? borderRadius,
      List<BoxShadow>? boxShadow,
      BoxShape? shape}) {
    if (url.trim() == '') {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          shape: shape ?? BoxShape.rectangle,
          borderRadius: isShapeCircular ? null : borderRadius ?? BorderRadius.circular(0),
          boxShadow: boxShadow,
          image: DecorationImage(
            image: AssetImage(placeholder),
            fit: fit ?? BoxFit.cover,
          ),
        ),
      );
    }
    if (!url.startsWith('http')) url = AppStrings.storageUrl + url;
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: isShapeCircular ? null : borderRadius ?? BorderRadius.circular(10),
          // borderRadius: borderRadius ?? BorderRadius.circular(10),
          shape: shape ?? BoxShape.rectangle,
          boxShadow: boxShadow,
          image: DecorationImage(
            image: imageProvider,
            fit: fit ?? BoxFit.cover,
          ),
        ),
      ),
      errorWidget: (context, error, dynamic a) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          shape: shape ?? BoxShape.rectangle,
          borderRadius: isShapeCircular ? null : borderRadius ?? BorderRadius.circular(10),
          // borderRadius: borderRadius ??  BorderRadius.circular(10),
          boxShadow: boxShadow,
          image: DecorationImage(
            image: AssetImage(placeholder),
            fit: fit ?? BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: boxShadow,
          color: AppColors.background,
        ),
      ),
    );
  }
}
