import 'package:flutter/cupertino.dart';

class CustomContainer extends StatelessWidget {
  final
  Widget widget;
  final
  bool isShadow;
  final
  bool isColor;
  final
  EdgeInsetsGeometry? margin;
  const CustomContainer(
      {super.key,
      this.isShadow = false,
      required this.widget,
      this.isColor = false,
      this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      margin:
          margin ?? const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      decoration: BoxDecoration(
        boxShadow: isShadow
            ? [
                const BoxShadow(
                  color: Color(0xff333333),
                  blurRadius: 15,
                  spreadRadius: 5,
                )
              ]
            : null,
        borderRadius: BorderRadius.circular(12),
        color: !isColor ? const Color(0xff333333) : null,
      ),
      child: widget,
    );
  }
}
