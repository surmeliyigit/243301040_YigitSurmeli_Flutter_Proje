import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/colors/app_colors.dart';

class LisTileDrawerItemWidget extends StatelessWidget {
  const LisTileDrawerItemWidget({
    super.key,
    required this.title,
    required this.leading,
    required this.onTap,
  });
  final String title;
  final Widget leading;
  final VoidCallback onTap;
  @override
  build(BuildContext context) {
    return ListTile(
      textColor: AppColors.textDark,
      iconColor: AppColors.primary,
      title: Text(title),
      leading: leading,
      onTap: onTap,
    );
  }
}
