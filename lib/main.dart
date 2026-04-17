import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/theme/app_colors.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/auth/login/login_screen.dart';
  import 'package:oto_yikama_randevu_hizmet_sistemi/features/auth/register/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Oto Randevu',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: AppColors.backgroundSecondary,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: AppColors.accent,
          elevation: 0, //burada neden elevation sifir verdik anlamadim
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.blueGrey[100],
          filled: true,
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: AppColors.textDark,
        ),
      ),
      home: LoginScreen(),
    );
  }
}
