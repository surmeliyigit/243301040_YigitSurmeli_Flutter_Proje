import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/constants/app_padding.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/theme/app_colors.dart';

//Login sayfasinda kullanilan TextField tanimlamasi
class CustomTextField extends StatelessWidget {
  CustomTextField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.isPassword,
    required this.icon,
    this.maxLength = 30,
    this.keyboardType = TextInputType.text,
    required this.controller,
  });
  final bool isPassword;
  final String hintText;
  final String labelText;
  final Icon icon;
  final int maxLength;
  final TextInputType keyboardType;
  final TextEditingController controller;
  Widget build(BuildContext context) {
    return Padding(
      padding: ScreenPadding.smallPadding,
      child: TextField(
        keyboardType: keyboardType,
        obscureText: isPassword,
        maxLength: maxLength,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          prefixIcon: isPassword ? Icon(Icons.password) : icon,
          border: OutlineInputBorder(),
          // fillColor: Theme.of(context).inputDecorationTheme.fillColor,//hocaya sor bunu ben theme a uzerinden aliyorum fillColori bir daha burada manuel olarak yazayim mi gorunum acisindan yoksa yazmayaim mi
          // filled: true,
        ),
        controller: controller,
      ),
    );
  }
}
