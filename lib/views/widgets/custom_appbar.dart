import 'package:flutter/material.dart';
import 'package:qr_scanner/utils/app_color.dart';
import 'package:qr_scanner/views/widgets/custom_text.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool leading;
  final Widget? actions;
  final PreferredSizeWidget? bottom;

  const CustomAppbar({
    super.key,
    required this.title,
    this.actions,
    this.leading = false,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: bottom,
      title: CustomText(
        text: title,
        fontWeight: FontWeight.bold,
      ),
      leadingWidth: 70,
      backgroundColor: Colors.transparent,
      actions: actions != null ? [actions!] : null,
      leading: leading
          ? GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.only(left: 14),
                  width: 40,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.grey.withOpacity(0.8),
                        blurRadius: 10,
                      ),
                    ],
                    color: AppColor.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_outlined,
                    color: AppColor.yellow,
                  ),
                ),
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(bottom == null
      ? kToolbarHeight
      : kToolbarHeight + bottom!.preferredSize.height);
}
