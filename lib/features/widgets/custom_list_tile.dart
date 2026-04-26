import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/theme/app_colors.dart';

class CustomListTileWidget extends StatelessWidget {
  const CustomListTileWidget({
    super.key,
    required String title,
    required Text subTitle,
    required VoidCallback onTap,
  }) : _onTap = onTap,
       _subTitle = subTitle,
       _title = title;
  final String _title;
  final Text _subTitle;
  final VoidCallback _onTap;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.backgroundPrimary,
      child: ListTile(
        leading: Icon(Icons.car_repair),
        title: Text(_title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: _subTitle,
        textColor: AppColors.accent,
        trailing: Icon(Icons.chevron_right),
        iconColor: AppColors.primary,
        onTap: _onTap,
      ),
    );
  }
}
