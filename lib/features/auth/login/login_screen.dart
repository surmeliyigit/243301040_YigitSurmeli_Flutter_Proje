import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/constants/app_padding.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/theme/app_colors.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/auth/login/widgets/custom_elevated_button.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/auth/login/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  final String _title = "Giriş Yap";
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: LoginScreenPadding.extraSmallPadding,
          child: Image.asset("assets/oto_yikama_logo.png"),
        ),
        title: Text("Giriş Ekranı"),
        actions: [
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: LoginScreenPadding.mediumPadding,
        child: ListView(//Scroll view bak
          children: [
            Padding(
              padding: LoginScreenPadding.smallPadding,
              child: Card(
                child: Image.asset("assets/image/login_background.png"),
                clipBehavior: Clip.antiAlias, //imagein koselerini kirpar
                elevation: 15,
              ),
            ),
            Text(
              "Oto Yıkama Hesabına Giriş Yap",
              style: TextTheme.of(context).titleMedium,
              textAlign: TextAlign.center,
            ),
            CustomTextField(
              hintText: "Mail giriniz",
              labelText: "Mail",
              isPassword: false,
              icon: Icon(Icons.email),
              keyboardType: TextInputType.emailAddress,
            ),
            CustomTextField(
              hintText: "Şifre giriniz",
              labelText: "Şifre",
              isPassword: true,
              icon: Icon(Icons.password),
            ),
            CustomElevatedButton(title: widget._title),
          ],
        ),
      ),
    );
  }
}
