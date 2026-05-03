import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/colors/app_colors.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/admin/admin_home.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/randevu/view/create_appointment_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/auth/login/login_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/auth/register/register_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/home/home_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/profile/profile_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/randevu/view/my_appointments.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/services/services_details.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/services/services_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/settings/settings_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Supabase bağlantısı
  await Supabase.initialize(
    url: 'https://eadfhmjsztnyglbeuhsy.supabase.co',
    anonKey: 'sb_publishable_woEogmW1deL4NHFYzTeNVQ_QXMmRsWC',
  );
  runApp(const MyApp());
}
final supabase = Supabase.instance.client;
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
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.blueGrey[100],
          filled: true,
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: AppColors.textDark,
        ),
        drawerTheme: DrawerThemeData(
          backgroundColor: AppColors.backgroundSecondary,
        ),
      ),
      home: LoginScreen(),
    );
  }
}
