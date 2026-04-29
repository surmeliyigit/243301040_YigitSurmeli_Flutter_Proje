import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/constants/app_padding.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/colors/app_colors.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_elevated_button.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_list_tile.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/dashboard_card_widget.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/drawer_item_list_tile.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  // int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: AppColors.backgroundSecondary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeader(
              //neden drawerheaderdan sonra bir cizgi oluyor nasil yok edecegim
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.blueGray,
                      radius: 30,
                      //ben neden CircleAvatara radius vermeme ragmen degismiyor radiusu ve ben neden listile icinde circleavatari leadinge ekledigimde neden sol tarafa yaslanmiyor
                      child: Icon(Icons.person, color: AppColors.primary),
                    ),
                    Text(
                      "Admin Yiğit",
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "yigit@gmail.com",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(color: AppColors.accent),
            ),
            LisTileDrawerItemWidget(
              title: "Randevular",
              leading: Icon(Icons.calendar_today),
              onTap: () {},
            ),
            LisTileDrawerItemWidget(
              title: "Hizmetleri Düzenle",
              leading: Icon(Icons.build),
              onTap: () {},
            ),
            LisTileDrawerItemWidget(
              title: "Müşteriler",
              leading: Icon(Icons.people),
              onTap: () {},
            ),
            LisTileDrawerItemWidget(
              title: "Ayarlar",
              leading: Icon(Icons.settings),
              onTap: () {},
            ),
            Spacer(),
            LisTileDrawerItemWidget(
              title: "Çıkış Yap",
              leading: Icon(Icons.logout),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Şirketinize Hoşgeldiniz"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.refresh))],
        centerTitle: false,
      ),
      body: Padding(
        padding: ScreenPadding.mediumPadding,
        child: ListView(
          children: [
            Padding(
              padding: ScreenPadding.largePadding,
              child: Text(
                "Günlük Özet",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: DashboardCard(
                    text: "Bugün",
                    subtext: "0 Randevu",
                    icon: Icon(Icons.calendar_today, color: AppColors.primary),
                  ),
                ),
                Expanded(
                  child: DashboardCard(
                    text: "Kazancınız",
                    subtext: "0 TL",
                    icon: Icon(Icons.attach_money, color: AppColors.green),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: DashboardCard(
                    text: "Bekleyen",
                    subtext: "0 Onay",
                    icon: Icon(Icons.access_time, color: AppColors.orange),
                  ),
                ),
                Expanded(
                  child: DashboardCard(
                    text: "İptal",
                    subtext: "0 Adet",
                    icon: Icon(Icons.cancel, color: AppColors.cancelColor),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Row(
              children: [
                Padding(
                  padding: ScreenPadding.largePadding,
                  child: Text(
                    "Yaklaşan Randevular",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            CustomListTileWidget(
              title: "34 FYT 387 - İç/Dış Yıkama",
              subTitle: Text("Müşteri: Yiğit Sürmeli\nSaat:11.00"),
              onTap: () {},
              trailing: SizedBox(
                height: 50,
                child: CustomElevatedButton(title: "Onayla", onPressed: () {}),
              ),
            ),
            CustomListTileWidget(
              title: "34 FYT 387 - İç/Dış Yıkama",
              subTitle: Text("Müşteri: Yiğit Sürmeli\nSaat:11.00"),
              onTap: () {},
              trailing: SizedBox(
                height: 50,
                child: CustomElevatedButton(title: "Onayla", onPressed: () {}),
              ),
            ),
            CustomListTileWidget(
              title: "34 FYT 387 - İç/Dış Yıkama",
              subTitle: Text("Müşteri: Yiğit Sürmeli\nSaat:11.00"),
              onTap: () {},
              trailing: SizedBox(
                height: 50,
                child: CustomElevatedButton(title: "Onayla", onPressed: () {}),
              ),
            ),
            CustomListTileWidget(
              title: "34 FYT 387 - İç/Dış Yıkama",
              subTitle: Text("Müşteri: Yiğit Sürmeli\nSaat:11.00"),
              onTap: () {},
              trailing: SizedBox(
                height: 50,
                child: CustomElevatedButton(title: "Onayla", onPressed: () {}),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: Container(
      //   height: 150,
      //   child: BottomNavigationBar(
      //     currentIndex: _selectedIndex,
      //     onTap: (index) {
      //       setState(() {
      //         _selectedIndex = index;
      //       });
      //     },
      //     backgroundColor: AppColors.lightBlue,
      //     items: [
      //       // BottomNavigationBarItem(icon: Icon(Icons.add), label: "Ana Sayfa"),Hocaya sor bunu ekledigimde neden verdigim ozellikler siliniyor
      //       BottomNavigationBarItem(icon: Icon(Icons.add), label: "Ana Sayfa"),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.add),
      //         label: "Gelen Randevular",
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.settings_outlined),
      //         label: "Ayarlar",
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
            // Card(
            //   child: ListTile(
            //     leading: Icon(Icons.car_repair),
            //     title: Text("34 FYT 387 - İç/Dış Yıkama"),
            //     subtitle: Text("Müşteri: Yiğit Sürmeli\nSaat:11.00"),
            //     trailing: SizedBox(
            //       height: 50,
            //       child: CustomElevatedButton(
            //         title: "Onayla",
            //         onPressed: () {},
            //       ),
            //     ),
            //   ),
            // ),
