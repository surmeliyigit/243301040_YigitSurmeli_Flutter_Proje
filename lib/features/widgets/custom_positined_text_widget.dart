import 'package:flutter/material.dart';

class PositinedTextWidget extends StatelessWidget {
  const PositinedTextWidget({
    super.key,
    this.maxLines,
    required this.top,
    required this.text,
    required this.style,
  });
  final double top;
  final String text;
  final TextStyle? style;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: 10,
      right: 10,
      child: Text(text, style: style),
    );
  }
}
