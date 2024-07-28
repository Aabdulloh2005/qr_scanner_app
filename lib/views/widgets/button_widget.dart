import 'package:flutter/material.dart';
import 'package:qr_scanner/utils/app_color.dart';

class ButtonWidget extends StatelessWidget {
  IconData icon;
  double size;
  Color color;
  Color iconColor;
  double? iconSize;
  ButtonWidget({
    super.key,
    required this.icon,
    this.size = 40,
    this.color = AppColor.grey,
    this.iconColor = AppColor.yellow,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      margin: const EdgeInsets.only(left: 14),
      width: size,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColor.grey.withOpacity(1),
            blurRadius: 10,
          ),
        ],
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: iconSize,
      ),
    );
  }
}
