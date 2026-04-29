import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/colors/app_colors.dart';

//Admin Sayfasindaysan CustomListTile onTap olmasin bunu daha sonradan uyarla
class CustomListTileWidget extends StatelessWidget {
  const CustomListTileWidget({
    super.key,
    required String title,
    required Text subTitle,
    required VoidCallback onTap,
    this.trailing = const Icon(Icons.chevron_right),
    this.leading = const Icon(Icons.car_repair),
  }) : _onTap = onTap,
       _subTitle = subTitle,
       _title = title;
  final String _title;
  final Text _subTitle;
  final VoidCallback _onTap;
  final Widget trailing;
  final Widget leading;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.backgroundPrimary,
      child: ListTile(
        leading: leading,
        title: Text(_title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: _subTitle,
        textColor: AppColors.accent,
        trailing: trailing,
        iconColor: AppColors.primary,
        onTap: _onTap,
      ),
    );
  }
}
