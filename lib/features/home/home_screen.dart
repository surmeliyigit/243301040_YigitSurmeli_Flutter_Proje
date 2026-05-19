import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/constants/app_padding.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/colors/app_colors.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/auth/users/user_data.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/profile/profile_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/randevu/view/create_appointment_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/randevu/view/my_appointments.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/services/services_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/settings/settings_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_hizmet.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_positined_text_widget.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/favorite_card.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/section_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeContent(
        onOtherTap: () {
          setState(() {
            _selectedIndex = 1;
          });
        },
      ),
      ServicesScreen(),
      MyAppointmentScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          _selectedIndex == 0
              ? "Hoşgeldin ${UserSession.user?['ad']}"
              : _selectedIndex == 1
              ? "Hizmetler Ekranı"
              : _selectedIndex == 2
              ? "Randevularım"
              : "Ayarlar",
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ProfileScreen();
                      },
                    ),
                  )
                  .then((_) {
                    setState(() {});
                  });
            },
            icon: const Icon(Icons.account_circle_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: ScreenPadding.mediumPadding,
        child: IndexedStack(index: _selectedIndex, children: pages),
      ),
      bottomNavigationBar: SizedBox(
        height: 150,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          backgroundColor: AppColors.lightBlue,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Ana Sayfa"),
            BottomNavigationBarItem(
              icon: Icon(Icons.cleaning_services),
              label: "Hizmetler",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: "Randevularım",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: "Ayarlar",
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 80,
        child: FloatingActionButton(
          backgroundColor: AppColors.secondary,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return CreateAppointmentScreen();
                },
              ),
            );
          },
          child: Text(
            "Randevu Al",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.backgroundPrimary,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class HomeContent extends StatelessWidget {
  final VoidCallback onOtherTap;

  const HomeContent({super.key, required this.onOtherTap});

  final String _titleServices = "Hizmetlerimiz";
  final String _titleFeature = "Öne Çıkan Hizmetler";

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: 200,
              child: Image.asset(
                "assets/image/car_background.png",
                fit: BoxFit.cover,
              ),
            ),
            Opacity(
              opacity: 0.3,
              child: Container(color: Colors.black, height: 200),
            ),
            PositinedTextWidget(
              top: 10,
              text: "Işıltınız Yollara Yansısın",
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            PositinedTextWidget(
              top: 90,
              text:
                  "Aracınıza hak ettiği değeri verin. Modern teknolojimiz ve titiz işçiliğimizle hizmetinizdeyiz.",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.white),
            ),
          ],
        ),

        Padding(
          padding: ScreenPadding.mediumPaddingTopBottom,
          child: SectionHeader(title: _titleServices),
        ),

        Row(
          children: [
            HizmetItem(
              imagePath: ImagePath.icTemizlemePath,
              text: "İç Temizleme",
            ),
            HizmetItem(
              imagePath: ImagePath.disTemizlemePath,
              text: "Dış Temizleme",
            ),
            HizmetItem(
              imagePath: ImagePath.klimaFilteTemizlemePath,
              text: "Klima Filtre Temizleme",
            ),
            HizmetItem(
              imagePath: ImagePath.cilalamaPath,
              text: "Araç Cilalama",
            ),
          ],
        ),

        Row(
          children: [
            HizmetItem(
              imagePath: ImagePath.paspasTemizlemePath,
              text: "Paspas Temizleme",
            ),
            HizmetItem(
              imagePath: ImagePath.koltukYikamaPath,
              text: "Araç Koltuk Yıkama",
            ),
            HizmetItem(
              imagePath: ImagePath.pasTemizlemePath,
              text: "Araçta Pas Temizleme",
            ),

            Expanded(
              child: GestureDetector(
                onTap: onOtherTap,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: AppColors.secondary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Diğer",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        Padding(
          padding: ScreenPadding.mediumPaddingTopBottom,
          child: SectionHeader(title: _titleFeature),
        ),

        SizedBox(
          height: 325,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              FavoriteCardWidget(
                title: "Dış Yıkama",
                describe:
                    "Aracınızın yüzeyi detaylı bir şekilde köpük ve suyla temizlenir",
              ),
              FavoriteCardWidget(
                title: "İç Yıkama",
                describe:
                    "Araç içi detaylı şekilde temizlenir. Koltuklar, torpido, kapı içleri ve tüm yüzeyler hijyenik ürünlerle silinerek ferah bir ortam sağlanır.",
              ),
              FavoriteCardWidget(
                title: "Koltuk Yıkama",
                describe:
                    "Koltuklar araçtan dikkatli şekilde sökülerek derinlemesine temizlenir.",
              ),
              FavoriteCardWidget(
                title: "Paspas Temizleme",
                describe: "Araç paspasları detaylı şekilde temizlenir.",
              ),
              FavoriteCardWidget(
                title: "Araç Cilalama",
                describe: "Araç yüzeyine özel cilalama işlemi uygulanır.",
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ImagePath {
  static const String icTemizlemePath = "assets/image/ic_temizleme.png";
  static const String disTemizlemePath = "assets/image/dis_temizleme.png";
  static const String klimaFilteTemizlemePath =
      "assets/image/klima_filtre_temizleme.png";
  static const String cilalamaPath = "assets/image/araba_cilalama.png";
  static const String paspasTemizlemePath = "assets/image/paspas_temizleme.png";
  static const String koltukYikamaPath = "assets/image/arac_koltuk_yikama.png";
  static const String pasTemizlemePath = "assets/image/pas_temizleme.png";
  static const String yedekPath = "assets/image/dis_temizleme.png";
  static const String digerPath = "assets/image/dis_temizleme.png";
}
