import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/theme/app_colors.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/auth/login/login_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/auth/users/user_data.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/home/home_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_elevated_button.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_navigator_text_button.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_text_field.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/constants/app_padding.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});
  final String _title = "Hesap Oluştur";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  //Listeyi final yerine static tanimladim cunku pushReplacement yaptigim icin bellekten siliniyor o yuzden static tanimlaik cunku static degiskenler program bitene kadar bellekte yer almayaya devam eder
  //Daha once hesap olusturmus birinin sifresi ile yeni hesap olusturan birini sifresi birbirinden farkli olsun bunu sayfaya ekle
  void _kayitOl() async {
    String name = _nameController.text.trim();
    String surname = _surnameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(seconds: 2));

    if (name.isEmpty ||
        surname.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen tüm alanları doldurun!")),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Geçerli bir e-posta giriniz!")),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
    bool mailVarMi = UserData.users.any((user) => user["email"] == email);

    if (mailVarMi) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Bu mail adresiyle zaten bir hesap oluşturulmuş!"),
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (password.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Oluşturulan şifre en az 4 haneden oluşmalıdır!"),
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
    if (!(password == confirmPassword)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Şifreler uyuşmuyor, lütfen tekrar kontrol ediniz."),
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
    setState(() {
      UserData.users.add({"email": email, "password": password});
    });
    _nameController.clear();
    _surnameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();

    Navigator.of(context).pop(
      MaterialPageRoute(
        builder: (context) {
          return LoginScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kayıt Ekranı")),
      body: Padding(
        padding: ScreenPadding.mediumPadding,
        child: ListView(
          children: [
            Padding(
              padding: ScreenPadding.smallPadding,
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
              controller: _nameController,
            ),
            CustomTextField(
              hintText: "Soyadınızı giriniz",
              labelText: "Soyadınız",
              isPassword: false,
              icon: Icon(Icons.person),
              controller: _surnameController,
            ),
            CustomTextField(
              hintText: "Mail giriniz",
              labelText: "Mail",
              isPassword: false,
              icon: Icon(Icons.email),
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
            ),
            CustomTextField(
              hintText: "Şifre giriniz",
              labelText: "Şifre",
              isPassword: true,
              icon: Icon(Icons.password),
              controller: _passwordController,
            ),
            CustomTextField(
              hintText: "Şifreyi tekrar giriniz",
              labelText: "Şifre tekrar",
              isPassword: true,
              icon: Icon(Icons.password),
              controller: _confirmPasswordController,
            ),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : CustomElevatedButton(
                    title: widget._title,
                    onPressed: () {
                      _kayitOl();
                    },
                  ),
            CustomNavigatorTextButton(
              text: "Zaten hesabınız var mı?",
              widget:
                  LoginScreen(), //buraya duzeltme yapacagiz poplarken route vermemize gerek yok
              type: NavigationType.pop,
            ),
          ],
        ),
      ),
    );
  }
}
