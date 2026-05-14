import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/constants/app_padding.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/colors/app_colors.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/admin/appointment_screen/appointments.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/admin/services/admin_services_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/admin/user_managment/user_management_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/auth/login/login_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/auth/users/user_data.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/settings/settings_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_elevated_button.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_list_tile.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/dashboard_card_widget.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/drawer_item_list_tile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminHomeScreen extends StatefulWidget {
  AdminHomeScreen({super.key});
  String loadingMessage = "Yükleniyor ...";
  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  bool isLoading = false;
  int todayCount = 0;
  int pendingCount = 0;
  int cancelledCount = 0;
  double totalPrice = 0;
  List<dynamic> pendingList = [];

  Future<void> loadTodayAppointments() async {
    setState(() => isLoading = true);

    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(const Duration(days: 1));

    final todayResponse = await Supabase.instance.client
        .from('randevu')
        .select('*, randevudetay(*, hizmet(listefiyati))')
        .gte('tarih', start.toIso8601String())
        .lt('tarih', end.toIso8601String());

    final pendingResponse = await Supabase.instance.client
        .from('randevu')
        .select('*')
        .eq('durum', 'Beklemede');
    final cancelledResponse = await Supabase.instance.client
        .from('randevu')
        .select('*')
        .eq('durum', 'iptal')
        .gte('tarih', start.toIso8601String())
        .lt('tarih', end.toIso8601String());
    final cancelledData = List<Map<String, dynamic>>.from(cancelledResponse);

    final pendingData = List<Map<String, dynamic>>.from(pendingResponse);
    double total = 0;

    for (var randevu in todayResponse) {
      final detaylar = randevu['randevudetay'];
      final durum = randevu['durum'];
      if (durum == 'iptal') continue;
      if (detaylar != null) {
        for (var detay in detaylar) {
          final hizmet = detay['hizmet'];
          if (hizmet != null) {
            total += (hizmet['listefiyati'] ?? 0).toDouble();
          }
        }
      }
    }

    setState(() {
      todayCount = todayResponse.length;
      totalPrice = total;
      pendingList = pendingData;
      pendingCount = pendingData.length;
      cancelledCount = cancelledData.length;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTodayAppointments();
  }

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
                      child: Icon(Icons.person, color: AppColors.primary),
                    ),
                    Text(
                      UserSession.user?['ad'] ?? '',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      UserSession.user?['eposta'] ?? '',
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
              title: "Onaylanan Haftalık Randevular",
              leading: Icon(Icons.calendar_today),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return AdminAppintmentScreen();
                    },
                  ),
                );
              },
            ),
            LisTileDrawerItemWidget(
              title: "Hizmetleri Düzenle",
              leading: Icon(Icons.build),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return AdminServicesScreen();
                    },
                  ),
                );
              },
            ),
            LisTileDrawerItemWidget(
              title: "Hesap Aktifleştir",
              leading: Icon(Icons.check_circle_rounded),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return UserManagementScreen();
                    },
                  ),
                );
              },
            ),
            LisTileDrawerItemWidget(
              title: "Ayarlar",
              leading: Icon(Icons.settings),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return SettingsScreen();
                    },
                  ),
                );
              },
            ),
            Spacer(),
            LisTileDrawerItemWidget(
              title: "Çıkış Yap",
              leading: Icon(Icons.logout),
              onTap: () async {
                final userId = UserSession.user?['kullaniciid'];

                if (userId != null) {
                  await Supabase.instance.client.from('logs').insert({
                    'kullaniciid': userId,
                    'islem': 'cikis_yapildi',
                    'hedef_tablo': 'kullanici',
                    'hedef_id': userId,
                  });
                }

                UserSession.user = null;

                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
                      },
                    ),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Şirketinize Hoşgeldiniz"),
        actions: [
          IconButton(
            onPressed: () {
              loadTodayAppointments();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
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
                    subtext: isLoading
                        ? widget.loadingMessage
                        : "$todayCount Randevu",
                    icon: Icon(Icons.calendar_today, color: AppColors.primary),
                  ),
                ),
                Expanded(
                  child: DashboardCard(
                    text: "Tahmini Kazancınız",
                    subtext: isLoading
                        ? widget.loadingMessage
                        : "$totalPrice TL",
                    icon: Icon(
                      Icons.attach_money,
                      color: AppColors.successColor,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: DashboardCard(
                    text: "Bekleyen",
                    subtext: isLoading
                        ? widget.loadingMessage
                        : "$pendingCount Onay",
                    icon: Icon(Icons.access_time, color: AppColors.orange),
                  ),
                ),
                Expanded(
                  child: DashboardCard(
                    text: "İptal",
                    subtext: isLoading
                        ? widget.loadingMessage
                        : "$cancelledCount Adet",
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
                    "Onay Bekleyen \nRandevular",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            pendingList.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "Bekleyen randevu yok",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true, //elemani kadar yer kapla
                    physics: NeverScrollableScrollPhysics(), //hocaya sor
                    itemCount: pendingList.length,
                    itemBuilder: (context, index) {
                      final item = pendingList[index];
                      return CustomListTileWidget(
                        title: "Randevu id: ${item['randevuid']}",
                        subTitle: Text(
                          "Durum: ${item['durum'] ?? 'Beklemede'}",
                        ), //bak buna
                        onTap: () {},

                        trailing: SizedBox(
                          height: 50,
                          child: CustomElevatedButton(
                            title: "Onayla",
                            onPressed: () async {
                              await Supabase.instance.client
                                  .from('randevu')
                                  .update({'durum': 'onaylandi'})
                                  .eq('randevuid', item['randevuid']);

                              setState(() {
                                pendingList.removeAt(index);
                                pendingCount--;
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
