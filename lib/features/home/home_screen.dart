import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/constants/app_padding.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/theme/app_colors.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/profile/profile_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/services/services_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/settings/settings_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_hizmet.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_navigator_text_button.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_positined_text_widget.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/favorite_card.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/section_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  final String _titleAppBar = "Tekrar Hoşgeldiniz";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> pages = [
    HomeContent(),
    ServicesScreen(),
    SettingsScreen(),
  ];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0
              ? widget._titleAppBar
              : _selectedIndex == 1
              ? "Hizmetler Ekranı"
              : "Ayarlar",
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return ProfileScreen();
                  },
                ),
              );
            },
            icon: Icon(Icons.account_circle_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: ScreenPadding.mediumPadding,
        child: IndexedStack(index: _selectedIndex, children: pages),
      ),
      bottomNavigationBar: Container(
        height: 150,
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: AppColors.lightBlue,
          items: [
            // BottomNavigationBarItem(icon: Icon(Icons.add), label: "Ana Sayfa"),Hocaya sor bunu ekledigimde neden verdigim ozellikler siliniyor
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "Ana Sayfa"),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "Hizmetler"),
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
          onPressed: () {},
          backgroundColor: AppColors.secondary,
          child: Text(
            "Randevu Al",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.backgroundPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});
  final String _titleServices = "Hizmetlerimiz";
  final String _titleFeature = "Öne Çıkan Hizmetler";
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Stack(
          //Header alani
          children: [
            Container(
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
            HizmetItem(
              imagePath: ImagePath.yedekPath,
              text: "Diğer Hizmetlerimiz",
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
                    "Koltuklar araçtan dikkatli şekilde sökülerek derinlemesine temizlenir. Kumaş ve deri yüzeylerdeki lekeler, kirler ve kötü kokular özel yıkama yöntemleriyle giderilir, ardından koltuklar güvenli şekilde tekrar monte edilir.",
              ),
              FavoriteCardWidget(
                title: "Paspas Temizleme",
                describe:
                    "Araç paspasları detaylı şekilde temizlenir, üzerindeki kir, çamur ve lekeler özel yıkama yöntemleriyle giderilerek hijyenik hale getirilir.",
              ),
              FavoriteCardWidget(
                title: "Araç Cilalama",
                describe:
                    "Araç yüzeyine uygulanan özel cilalama işlemi ile boya üzerindeki matlık giderilir, parlaklık artırılır ve aracınız daha canlı bir görünüm kazanır.",
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
}
