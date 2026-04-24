import 'package:flutter/material.dart';

class HizmetItem extends StatelessWidget {
  const HizmetItem({
    super.key,
    required this.imagePath,
    required this.text,
    this.textAlign = TextAlign.center,
  });
  final String imagePath;
  final String text;
  final TextAlign textAlign;
  final TextOverflow overflow = TextOverflow.ellipsis;
  final int maxLines = 2;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CircleAvatar(radius: 30, backgroundImage: AssetImage(imagePath)),
            Text(
              text,
              textAlign: textAlign,
              overflow: overflow,
              maxLines: maxLines,
            ),
          ],
        ),
      ),
    );
  }
}
