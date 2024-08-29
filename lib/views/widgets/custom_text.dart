import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final
  String text;
  final
  Color? color;
  final
  double? size;
  final
  FontWeight? fontWeight;
  final
  TextAlign? textAlign;

  const CustomText({
    super.key,
    this.color,
    this.fontWeight,
    this.size,
    this.textAlign,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign,
        style: GoogleFonts.itim().copyWith(
          color: color,
          fontWeight: fontWeight,
          fontSize: size,
        ));
  }
}
