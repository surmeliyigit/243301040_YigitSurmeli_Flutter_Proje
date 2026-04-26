import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/constants/app_padding.dart';

class CustomImageCard extends StatelessWidget {
  const CustomImageCard({super.key, required this.imagePath});
  final String imagePath;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ScreenPadding.smallPadding,
      child: Card(
        child: Image.asset(imagePath),
        clipBehavior: Clip.antiAlias, //imagein koselerini kirpar
        elevation: 15,
      ),
    );
  }
}
