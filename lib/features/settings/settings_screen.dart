import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/constants/app_padding.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/colors/app_colors.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/utils/snackbar_helper.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/auth/login/login_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/auth/users/user_data.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/profile/profile_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_elevated_button.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_sheet_text_field.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/settings_tile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  final String title = "Ayarlar";

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController _changePasswordController = TextEditingController();
  TextEditingController _repeatPasswordController = TextEditingController();

  Future<void> sifreGuncelle() async {
    final newPassword = _changePasswordController.text.trim();
    final repeatPassword = _repeatPasswordController.text.trim();

    if (newPassword.isEmpty || repeatPassword.isEmpty) {
      throw "Lütfen tüm alanları doldurunuz!";
    }
    if (newPassword.length < 4) {
      throw "Şifre en az 4 haneden oluşmalıdır!";
    }
    if (newPassword != repeatPassword) {
      throw "Lütfen şifre alanlarını kontrol ediniz şifreler uyuşmuyor!";
    }
    final userId = UserSession.user?['kullaniciid'];
    await Supabase.instance.client
        .from('kullanici')
        .update({'sifre': newPassword})
        .eq('kullaniciid', userId);
    _changePasswordController.clear();
    _repeatPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final role = UserSession.user?['roller']?['rol'] ?? '';
    final isAdmin = role == "Admin";
    return Scaffold(
      appBar:
          isAdmin //UserSession.user?['roller']['rolid'] == 1 deyınce neden calismiyor
          ? AppBar(title: Text("Ayarlar"), centerTitle: false)
          : null,
      body: Padding(
        padding: UserSession.user?['rolid'] != 1
            ? EdgeInsets.all(0)
            : ScreenPadding.mediumPadding,
        child: Column(
          children: [
            ListTile(
              textColor: AppColors.textDark,
              contentPadding: EdgeInsets.only(left: 5, right: 24),
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage("assets/image/car_background.png"),
              ),
              title: Text(
                "Çıkış Yap",
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("${UserSession.user?['ad']}"),
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
                    bool isLoadingSheet = false;
                    return StatefulBuilder(
                      builder: (context, setStateSheet) {
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
                            CustomSheetTextField(
                              hintText: "Yeni şifre giriniz",
                              controller: _changePasswordController,
                              isPassword: true,
                              icon: Icon(Icons.password),
                              isDescribeController: false,
                            ),
                            CustomSheetTextField(
                              hintText: "Şifre tekrar",
                              controller: _repeatPasswordController,
                              isPassword: true,
                              icon: Icon(Icons.password),
                              isDescribeController: false,
                            ),
                            Center(
                              child: isLoadingSheet
                                  ? CircularProgressIndicator()
                                  : CustomElevatedButton(
                                      title: "Şifreyi Değiştir",
                                      onPressed: () async {
                                        setStateSheet(() {
                                          isLoadingSheet = true;
                                        });

                                        try {
                                          await Future.delayed(
                                            Duration(seconds: 2),
                                          );

                                          await sifreGuncelle();

                                          Navigator.of(context).pop();

                                          SnackBarHelper.showSuccess(
                                            context,
                                            "Şifreniz güncellendi!",
                                          );
                                        } catch (e) {
                                          Navigator.of(context).pop();
                                          SnackBarHelper.showError(
                                            context,
                                            "$e",
                                          );
                                        }

                                        setStateSheet(() {
                                          isLoadingSheet = false;
                                        });
                                      },
                                    ),
                            ),
                            SizedBox(height: 20),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
            // Divider(),
            // SettingsTile(
            //   leading: Icon(Icons.notifications_on_outlined),
            //   title: "Bildirimleri Aç", 
            //   onTap: () {},
            // ),
            Divider(),
            !isAdmin
                ? SettingsTile(
                    leading: Icon(Icons.account_box_outlined),
                    title: "Hesabı Kaldır",
                    onTap: () async {
                      final userId = UserSession.user?['kullaniciid'];
                      if (userId == null) return;

                      await Supabase.instance.client
                          .from('kullanici')
                          .update({'durum': 'pasif'})
                          .eq('kullaniciid', userId);

                      UserSession.user = null;

                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
