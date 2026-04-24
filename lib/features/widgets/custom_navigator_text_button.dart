import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/theme/app_colors.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/auth/login/login_screen.dart';

enum NavigationType { pop, push }

class CustomNavigatorTextButton extends StatelessWidget {
  const CustomNavigatorTextButton({
    super.key,
    required String text,
    required Widget widget,
    required NavigationType type,
  }) : _type = type,
       _widget = widget,
       _text = text;
  final String _text;
  final Widget _widget;
  final NavigationType _type;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (_type == NavigationType.pop) {
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (Context) {
                return _widget;
              },
            ),
          );
        }
      },
      child: Text(
        _text,
        style: TextStyle(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: TextButton.styleFrom(foregroundColor: AppColors.secondary),
    );
  }
}
