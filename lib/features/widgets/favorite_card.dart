import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/theme/app_colors.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/home/home_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_navigator_text_button.dart';

class FavoriteCardWidget extends StatelessWidget {
  const FavoriteCardWidget({
    super.key,
    required String title,
    required String describe,
  }) : _describe = describe,
       _title = title;
  final String _title;
  final String _describe;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.blueGray,
      elevation: 5,
      child: Stack(
        children: [
          Container(
            child: Column(
              children: [
                Text(_title, style: Theme.of(context).textTheme.titleMedium),
                Text(
                  "Açıklama:",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(_describe, textAlign: TextAlign.center),
              ],
            ),
            width: 150,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CustomNavigatorTextButton(
              text: "Hızlı Randevu",
              widget: HomeScreen(),
              type: NavigationType.push,
            ),
          ),
        ],
      ),
    );
  }
}
