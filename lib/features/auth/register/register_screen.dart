import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/colors/app_colors.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/utils/snackbar_helper.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/auth/login/login_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_elevated_button.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_list_tile.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_navigator_text_button.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_text_field.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/constants/app_padding.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  String? selectedIlce;
  int? selectedIlceId;
  String? selectedIl;
  int? selectedIlId;
  bool ilceEnabled = false;
  List<Map<String, dynamic>> iller = [];
  List<Map<String, dynamic>> ilceler = [];
  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  Future<void> _kayitOl() async {
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
      SnackBarHelper.showError(
        context,
        "Oluşturulan şifre en az 4 haneden oluşmalıdır!",
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
    if (!(password == confirmPassword)) {
      SnackBarHelper.showError(
        context,
        "Şifreler uyuşmuyor, lütfen tekrar kontrol ediniz.",
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      final existingUser = await Supabase.instance.client
          .from('kullanici')
          .select()
          .eq('eposta', email)
          .maybeSingle();
      if (existingUser != null) {
        SnackBarHelper.showError(
          context,
          "Bu mail adresiyle zaten bir hesap oluşturulmuş!",
        );

        setState(() {
          _isLoading = false;
        });
        return;
      }
      await Supabase.instance.client.from('kullanici').insert({
        'ad': name,
        'soyad': surname,
        'eposta': email,
        'sifre': password,
        'rolid': 2,
        'ilceid': selectedIlceId,
      });
      SnackBarHelper.showSuccess(context, "Kayıt Başarılı!");
      _nameController.clear();
      _surnameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return LoginScreen();
          },
        ),
      );
    } catch (e) {
      SnackBarHelper.showError(context, "Bir hata oluştu $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> fetchIller() async {
    final data = await Supabase.instance.client
        .from('iller')
        .select()
        .order('iladi');

    setState(() {
      iller = List<Map<String, dynamic>>.from(data);
    });
  }

  Future<void> fetchIlceler(int ilid) async {
    final data = await Supabase.instance.client
        .from('ilceler')
        .select()
        .eq('ilid', ilid);

    setState(() {
      ilceler = List<Map<String, dynamic>>.from(data);
      ilceEnabled = true;

      selectedIlce = null;
      selectedIlceId = null;
    });
  }

  Future<void> selectIl() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      backgroundColor: AppColors.blueGrey,
      builder: (context) {
        return ListView.builder(
          itemCount: iller.length,
          itemBuilder: (context, index) {
            final il = iller[index];

            return ListTile(
              title: Text(il['iladi']),
              onTap: () {
                Navigator.pop(context, il);
              },
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedIl = result['iladi'];
        selectedIlId = result['ilid'];

        selectedIlce = null;
        selectedIlceId = null;
        ilceEnabled = true;
      });

      fetchIlceler(selectedIlId!);
    }
  }

  Future<void> selectIlce() async {
    if (selectedIlId == null) {
      SnackBarHelper.showError(context, "Önce il seçmelisin!");
      return;
    }

    if (!ilceEnabled) return;

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      backgroundColor: AppColors.blueGrey,
      builder: (context) {
        return ListView.builder(
          itemCount: ilceler.length,
          itemBuilder: (context, index) {
            final ilce = ilceler[index];

            return ListTile(
              title: Text(ilce['ilceadi']),
              onTap: () {
                Navigator.pop(context, ilce);
              },
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedIlce = result['ilceadi'];
        selectedIlceId = result['ilceid'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchIller();
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
            CustomListTileWidget(
              title: selectedIl ?? "Yaşadığınız İl",
              subTitle: const Text(""),
              onTap: selectIl,
            ),
            SizedBox(height: 20),
            CustomListTileWidget(
              title: selectedIlce ?? "Yaşadığınız İlçe",
              subTitle: const Text(""),
              onTap: selectIlce,
            ),
            SizedBox(height: 20),
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
