import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/constants/app_padding.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/theme/app_colors.dart';

//Login sayfasinda kullanilan TextField tanimlamasi
class LoginTextField extends StatelessWidget {
  const LoginTextField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.isPassword,
  });
  final bool isPassword;
  final String hintText;
  final String labelText;
  final int maxLength = 30;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: LoginScreenPadding.smallPadding,
      child: TextField(
        obscureText: isPassword,
        maxLength: maxLength,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          prefixIcon: isPassword ? Icon(Icons.password) : Icon(Icons.email),
          border: OutlineInputBorder(),
          fillColor: Colors.blueGrey[100],
          filled: true,
        ),
      ),
    );
  }
}

//Uygulama genelinde kullanilan custom ElevatedButton
class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
      onPressed: () {},
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(color: AppColors.white),
      ),
    );
  }
}
