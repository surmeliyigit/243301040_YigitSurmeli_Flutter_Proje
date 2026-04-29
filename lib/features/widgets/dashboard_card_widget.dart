import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/constants/app_padding.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/colors/app_colors.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    required this.text,
    required this.subtext,
    required this.icon,
  });
  final String text;
  final String subtext;
  final Icon icon;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.blueGray,
      elevation: 10,
      child: Padding(
        padding: ScreenPadding.mediumPaddingTopBottom,
        child: Column(
          children: [
            icon,
            SizedBox(height: 10),
            Text(text, style: TextStyle(color: Colors.grey[700])),
            SizedBox(height: 5),
            Text(subtext),
          ],
        ),
      ),
    );
  }
}
