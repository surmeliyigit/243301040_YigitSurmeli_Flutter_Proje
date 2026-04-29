import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/colors/app_colors.dart';

//Uygulama genelinde kullanilan custom ElevatedButton
class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({super.key, this.buttonBackground=AppColors.primary,required this.title, required this.onPressed});
  final String title;
  final VoidCallback onPressed;
  final Color buttonBackground;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: buttonBackground),
      onPressed: onPressed,
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(color: AppColors.white),
      ),
    );
  }
}
