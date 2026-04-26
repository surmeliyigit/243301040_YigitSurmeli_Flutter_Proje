import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/constants/app_padding.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_elevated_button.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _mailController = TextEditingController();
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
                  backgroundImage: AssetImage("assets/image/pas_temizleme.png"),
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
            CustomTextField(
              hintText: "Telefon numaranızı giriniz",
              labelText: "Telefon",
              isPassword: false,
              icon: Icon(Icons.phone),
              controller: _phoneController,
              maxLength: 13
            ),
            CustomTextField(
              hintText: "E-posta adresinizi giriniz.",
              labelText: "Mail",
              isPassword: false,
              icon: Icon(Icons.mail),
              controller: _mailController,
            ),
            CustomElevatedButton(
              //listview icinde spacer() atınca neden hata verşyor
              title: "Değişiklikleri Kaydet",
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
