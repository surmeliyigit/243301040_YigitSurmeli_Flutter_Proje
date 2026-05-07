import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/colors/app_colors.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/constants/app_padding.dart';

class CustomSheetTextField extends StatelessWidget {
  const CustomSheetTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.isPassword,
    required this.icon,
    this.isDescribeController,
  });
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final Icon icon;
  final isDescribeController;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ScreenPadding.smallPadding,
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: icon,
          fillColor: AppColors.backgroundSecondary,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
          hintText: hintText,
        ),
        maxLength: isDescribeController ? 75 : 30,
        controller: controller,
      ),
    );
  }
}
