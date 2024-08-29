import 'package:flutter/material.dart';
import 'package:qr_scanner/utils/app_color.dart';

class ButtonWidget extends StatelessWidget {
  final
  IconData icon;
  final
  double size;
  final
  Color color;
  final
  Color iconColor;
  final
  double? iconSize;
  const ButtonWidget({
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
