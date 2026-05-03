import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/constants/app_padding.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/colors/app_colors.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/utils/snackbar_helper.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/admin/admin_home.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/auth/users/user_data.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_elevated_button.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_image_card.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_navigator_text_button.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_text_field.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/auth/register/register_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/home/home_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // 1. Temel Validasyonlar (Zaten kodunda var)
    if (email.isEmpty || password.isEmpty) {
      SnackBarHelper.showError(context, "Lütfen tüm alanları doldurun!");
      setState(() {
        _isLoading = false;
      });
      return;
    }
    if (!email.contains('@')) {
      SnackBarHelper.showError(context, "Geçerli bir e-posta giriniz!");
      setState(() {
        _isLoading = false;
      });
      return;
    }
    if (password.length < 4) {
      SnackBarHelper.showError(context, "Şifre en az 4 haneden oluşmaktadır!");
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      final response = await Supabase.instance.client
          .from('kullanici')
          .select('*, roller(rol)')
          .eq('eposta', email)
          .eq('sifre', password)
          .maybeSingle();
      if (response == null) {
        SnackBarHelper.showError(context, "E-posta veya şifre hatalı!");
        setState(() {
          _isLoading = false;
        });
        return;
      }
      UserSession.user = response;
      final roleData = response['roller'];
      final String userRole = roleData != null ? roleData['rol'] : 'Kullanıcı';

      _emailController.clear();
      _passwordController.clear();
        //admin girisi icin yonledirme
      if (userRole == 'Admin') {
        SnackBarHelper.showSuccess(context, "Hoş geldiniz Admin!");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
        );
      } else {
        //Normal kullanıcı girisi icin yonlendirme
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      SnackBarHelper.showError(context, "Bir hata oluştu: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
