import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/constants/app_padding.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/colors/app_colors.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/auth/login/login_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/profile/profile_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/services/services_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_elevated_button.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_text_field.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/settings_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  final String title = "Ayarlar";

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController _changePasswordController = TextEditingController();
  TextEditingController _repeatPasswordController = TextEditingController();
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
              Navigator.of(context).pushAndRemoveUntil(
                //pushReplacemnetda kullanabilirim zaten sadece  bir sayfa stack de olacak
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
                (route) => false,
              );
            },
          ),
          Divider(),
          SettingsTile(
            leading: Icon(Icons.person_outline),
            title: "Kullanıcı Profili",
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return ProfileScreen();
                  },
                ),
              );
            },
          ),
          Divider(),
          SettingsTile(
            leading: Icon(Icons.lock_outline),
            title: "Şifreyi Değiştir",
            onTap: () {
              showModalBottomSheet(
                showDragHandle: true, //tutamac ekler panele
                backgroundColor: AppColors.blueGrey,
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: ScreenPadding.smallPadding,
                        child: Text(
                          "Yeni Şifrenizi Oluşturunuz:",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ChangePasswordTextField(
                        hintText: "Yeni şifre giriniz",
                        controller: _changePasswordController,
                      ),
                      ChangePasswordTextField(
                        hintText: "Şifre tekrar",
                        controller: _repeatPasswordController,
                      ),
                      Center(
                        child: CustomElevatedButton(
                          title: "Şifreyi Değiştir",
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                },
              );
            },
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

class ChangePasswordTextField extends StatelessWidget {
  const ChangePasswordTextField({
    super.key,
    required this.hintText,
    required this.controller,
  });
  final String hintText;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ScreenPadding.smallPadding,
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.password),
          fillColor: AppColors.backgroundSecondary,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
          hintText: hintText,
        ),
        maxLength: 30,
        controller: controller,
      ),
    );
  }
}
