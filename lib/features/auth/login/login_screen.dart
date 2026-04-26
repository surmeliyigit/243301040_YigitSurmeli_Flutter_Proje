import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/constants/app_padding.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/theme/app_colors.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/auth/users/user_data.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_elevated_button.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_image_card.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_navigator_text_button.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_text_field.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/auth/register/register_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  final String _title = "Giriş Yap";
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

//trim() metoduna bak projene ekle
class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _girisYap() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(seconds: 2));
    // String emailTest = "yigit@gmail.com";
    // String passwordTest = "1234";
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
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
    if (password.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Şifre en az 4 haneden oluşmaktadır!")),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
    bool isUser = UserData.users.any(
      (user) => user["email"] == email && user["password"] == password,
    );
    if (!isUser) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("E-posta veya şifreyi hatalı girdiniz!")),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
    setState(() {
      _isLoading = false;
    });
    _emailController
        .clear(); //bu kisim ram sisirmesini engeller kullanici login sayfasina tekar dondugunde textfieldlarin icerikleri temizlenir
    _passwordController.clear();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return HomeScreen();
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: ScreenPadding.extraSmallPadding,
          child: Image.asset("assets/oto_yikama_logo.png"),
        ),
        title: Text("Giriş Ekranı"),
        actions: [
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: ScreenPadding.mediumPadding,
        child: ListView(
          //Scroll view bak
          children: [
            CustomImageCard(imagePath: "assets/image/login_background.png"),
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
              controller: _emailController,
            ),
            CustomTextField(
              hintText: "Şifre giriniz",
              labelText: "Şifre",
              isPassword: true,
              icon: Icon(Icons.password),
              controller: _passwordController,
            ),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : CustomElevatedButton(
                    title: widget._title,
                    onPressed: () {
                      _girisYap();
                    },
                  ),
            CustomNavigatorTextButton(
              text: "Hesabınız yok mu?",
              widget: RegisterScreen(),
              type: NavigationType.push,
            ),
          ],
        ),
      ),
    );
  }
}

class ImagePath {}
