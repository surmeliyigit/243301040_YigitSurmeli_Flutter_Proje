import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/auth/users/user_data.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/admin/admin_home.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/auth/login/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    if (userString != null) {
      final cachedUser = jsonDecode(userString);

      final freshUser = await Supabase.instance.client
          .from('kullanici')
          .select('*, roller(rol)')
          .eq('kullaniciid', cachedUser['kullaniciid'])
          .maybeSingle();

      if (freshUser == null || freshUser['durum'] != 'aktif') {
        await prefs.remove('user');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
        return;
      }

      UserSession.user = freshUser;

      final roleData = freshUser['roller'];
      final String userRole = roleData != null ? roleData['rol'] : 'Kullanıcı';

      if (userRole == 'Admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => AdminHomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
