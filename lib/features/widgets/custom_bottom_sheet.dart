import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/colors/app_colors.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_elevated_button.dart';

Future<dynamic> showCancelAppointment(
  BuildContext context,
  String text,
  VoidCallback onConfirm,
) {
  return showModalBottomSheet(
    backgroundColor: AppColors.blueGrey,
    context: context,
    builder: (context) {
      return Container(
        height: 200,
        width: double.infinity,
        child: Column(
          children: [
            Spacer(),
            CustomElevatedButton(
              title: text,
              onPressed: onConfirm,
              buttonBackground: AppColors.cancelColor,
            ),
            Spacer(),
          ],
        ),
      );
    },
  );
}
