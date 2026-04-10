import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/screens/login.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Oto Randevu',
      theme: ThemeData(
      ),
      home:Login() ,
    );
  }
}

