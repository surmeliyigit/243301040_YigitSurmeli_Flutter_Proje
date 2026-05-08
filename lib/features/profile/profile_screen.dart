import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/constants/app_padding.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/utils/snackbar_helper.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/auth/users/user_data.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_elevated_button.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _mailController = TextEditingController();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final userId = UserSession.user?['kullaniciid'];
    final response = await Supabase.instance.client
        .from('kullanici')
        .select()
        .eq('kullaniciid', userId)
        .single();
    _nameController.text = response['ad'] ?? "";
    _surnameController.text = response['soyad'] ?? "";
    _mailController.text = response['eposta'] ?? "";
  }

  Future<void> bilgileriGuncelle() async {
    final name = _nameController.text.trim();
    final surname = _surnameController.text.trim();
    final email = _mailController.text.trim();
    final userId = UserSession.user?['kullaniciid'];
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(seconds: 2));

    if (userId == null) {
      throw "Kullanıcı bulunamadı!";
    }
    try {
      if (name.isEmpty || surname.isEmpty || email.isEmpty) {
        throw "Lütfen tüm alanları doldurunuz!";
      }
      if (!email.contains("@")) {
        throw "Geçerli bir e-posta giriniz!";
      }
      final existing = await Supabase.instance.client
          .from('kullanici')
          .select()
          .eq('eposta', email)
          .maybeSingle();
      if (existing != null && existing['kullaniciid'] != userId) {
        throw "E-posta zaten kullanılıyor!";
      }
      await Supabase.instance.client
          .from('kullanici')
          .update({'ad': name, 'soyad': surname, 'eposta': email})
          .eq('kullaniciid', userId);
      SnackBarHelper.showSuccess(context, "Değişiklikler kaydedildi!");
      UserSession.user!['ad'] = name;
      UserSession.user!['soyad'] = surname;
      UserSession.user!['eposta'] = email;
      if (!mounted) {
        return;
      }
    } catch (e) {
      SnackBarHelper.showError(context, "Hata oluştu $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _mailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kullanıcı Profili")),
      body: Padding(
        padding: ScreenPadding.mediumPadding,
        child: ListView(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: CircleAvatar(
                  backgroundImage: AssetImage(
                    "assets/image/car_background.png",
                  ),
                  radius: 75,
                ),
              ),
            ),
            CustomTextField(
              hintText: "Adınız",
              labelText: "Ad",
              isPassword: false,
              icon: Icon(Icons.person),
              controller: _nameController,
            ),
            CustomTextField(
              hintText: "Soyadınız",
              labelText: "Soyad",
              isPassword: false,
              icon: Icon(Icons.person),
              controller: _surnameController,
            ),
            // CustomTextField(
            //   hintText: "Telefon numaranızı giriniz",
            //   labelText: "Telefon",
            //   isPassword: false,
            //   icon: Icon(Icons.phone),
            //   controller: _phoneController,
            //   maxLength: 13,
            // ),
            CustomTextField(
              hintText: "E-posta adresinizi giriniz.",
              labelText: "Mail",
              isPassword: false,
              icon: Icon(Icons.mail),
              controller: _mailController,
            ),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : CustomElevatedButton(
                    title: "Değişiklikleri Kaydet",
                    onPressed: () async {
                      await bilgileriGuncelle();
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
