import 'package:flutter/material.dart';

class TextMessageWidget extends StatelessWidget {
  const TextMessageWidget({
    super.key,
    required this.label,
    this.fontSize = 18,
    this.color,
    this.fontWeight,
  });

  final String label;
  final double fontSize;
  final Color? color;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: color ?? Colors.white,
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.w500,
      ),
    );
  }
}
