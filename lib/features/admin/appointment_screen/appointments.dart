import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/constants/app_padding.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/utils/snackbar_helper.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_bottom_sheet.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_list_tile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class AdminAppintmentScreen extends StatefulWidget {
  const AdminAppintmentScreen({super.key});

  @override
  State<AdminAppintmentScreen> createState() => _AdminAppintmentScreenState();
}

class _AdminAppintmentScreenState extends State<AdminAppintmentScreen> {
  List<dynamic> randevular = [];
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    loadAppointment();
  }

  Future<void> loadAppointment() async {
    setState(() {
      _isLoading = true;
    });
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(Duration(days: 7));
    final response = await Supabase.instance.client
        .from('randevu')
        .select('''
      *,
      araclar(*),
      randevudetay(
        *,
        hizmet(*)
      )
    ''')
        .gte('tarih', start.toIso8601String())
        .lt('tarih', end.toIso8601String())
        .eq('durum', 'onaylandi')
        .order('tarih', ascending: true);
    setState(() {
      randevular = response;
      _isLoading = false;
    });
  }

  Future<void> deleteAppointment(int id) async {
    try {
      await Supabase.instance.client
          .from('randevu')
          .update({'durum': 'iptal'})
          .eq('randevuid', id);
      if (mounted) {
        SnackBarHelper.showSuccess(
          context,
          "Randevu ve bağlı tüm kayıtlar başarıyla silindi.",
        );
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, "Silme işlemi başarısız: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Haftadaki Randevularınız"),
        centerTitle: false,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: ScreenPadding.mediumPadding,
              child: randevular.isEmpty
                  ? const Center(child: Text("Henüz onaylanan randevu yok"))
                  : ListView.builder(
                      itemCount: randevular.length,
                      itemBuilder: (context, index) {
                        final tmp = randevular[index]; //bu kısma bak
                        final arac = tmp['araclar'];
                        final detayList = tmp['randevudetay'] as List<dynamic>?;
                        final detay =
                            (detayList != null && detayList.isNotEmpty)
                            ? detayList[0]
                            : null;
                        final hizmet = detay != null ? detay['hizmet'] : null;
                        final tarih = tmp['tarih'];
                        final saat = tmp['secilensaat'];
                        final dateTime = DateTime.parse(tarih).toLocal();
                        final formattedDate = DateFormat(
                          'dd.MM.yyyy',
                        ).format(dateTime);
                        return CustomListTileWidget(
                          trailing: IconButton(
                            onPressed: () {
                              showCancelAppointment(
                                context,
                                "Randevuyu İptal Et",
                                () async {
                                  await deleteAppointment(tmp['randevuid']);
                                  Navigator.pop(context);
                                  await loadAppointment();
                                },
                              );
                            },
                            icon: Icon(Icons.more_vert),
                          ),
                          title: "Plaka: " + "${arac?['plaka'] ?? 'Plaka yok'}",
                          subTitle: Text(
                            "Hizmet: ${hizmet?['hizmetadi'] ?? 'Bilinmiyor'}\n"
                            "Tarih: $formattedDate\n"
                            "Saat: $saat", //sor hocaya
                          ),
                          onTap: () {},
                        );
                      },
                    ),
            ),
    );
  }
}
