import 'package:flutter/material.dart';
import 'package:qr_scanner/utils/app_color.dart';
import 'package:qr_scanner/views/widgets/custom_text.dart';

class Helpers {
  static void showSnackBar(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: AppColor.yellow,
        content: CustomText(
          text: title,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
  
}
