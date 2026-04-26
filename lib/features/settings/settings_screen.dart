import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/constants/app_padding.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/theme/app_colors.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/auth/login/login_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/profile/profile_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/services/services_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/settings_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  final String title = "Ayarlar";

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListTile(
            textColor: AppColors.textDark,
            contentPadding: EdgeInsets.only(left: 5, right: 24),
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage("assets/image/car_background.png"),
            ),
            title: Text(
              "Hoş Geldiniz",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Yiğit"),
            trailing: Icon(Icons.logout),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          ),
          Divider(),
          SettingsTile(
            leading: Icon(Icons.person_outline),
            title: "Kullanıcı Profili",
            onTap: () {},
          ),
          Divider(),
          SettingsTile(
            leading: Icon(Icons.lock_outline),
            title: "Sifreyi Değiştir",
            onTap: () {},
          ),
          Divider(),
          SettingsTile(
            leading: Icon(Icons.notifications_on_outlined),
            title: "Bildirimleri Aç",
            onTap: () {},
          ),
          Divider(),
        ],
      ),
    );
  }
}
