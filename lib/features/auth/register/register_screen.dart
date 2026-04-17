import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/auth/login/login_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/auth/login/widgets/custom_elevated_button.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/auth/login/widgets/custom_text_field.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/constants/app_padding.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.chevron_left)),
        title: Text("Kayıt Ekranı"),
      ),
      body: Padding(
        padding: LoginScreenPadding.mediumPadding,
        child: ListView(
          children: [
            Padding(
              padding: LoginScreenPadding.smallPadding,
              child: Text(
                "Aracın için Hesap Oluştur",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30),
            CustomTextField(
              hintText: "Adınızı giriniz",
              labelText: "Adınız",
              isPassword: false,
              icon: Icon(Icons.person),
            ),
            CustomTextField(
              hintText: "Soyadınızı giriniz",
              labelText: "Soyadınız",
              isPassword: false,
              icon: Icon(Icons.person),
            ),
            CustomTextField(
              hintText: "Mail giriniz",
              labelText: "Mail",
              isPassword: false,
              icon: Icon(Icons.email),
              keyboardType: TextInputType.emailAddress,
            ),
            CustomTextField(
              hintText: "Şİfre giriniz",
              labelText: "Şifre",
              isPassword: true,
              icon: Icon(Icons.password),
            ),
            Container(
              width:
                  300, //ben burada width:300 dememe ragmen neden button kuculmedi anlamadim ben constraints konusunu hocaya sor
              child: CustomElevatedButton(title: "Hesap Oluştur"),
            ),
          ],
        ),
      ),
    );
  }
}
