import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/utils/snackbar_helper.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/auth/users/user_data.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_bottom_sheet.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_list_tile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyAppointmentScreen extends StatefulWidget {
  const MyAppointmentScreen({super.key});

  @override
  State<MyAppointmentScreen> createState() => _MyAppointmentScreenState();
}

class _MyAppointmentScreenState extends State<MyAppointmentScreen> {
  late Future<List> appointmentsFuture;
  Future<List> getAppointments() async {
    final araclar = await Supabase.instance.client
        .from('araclar')
        .select()
        .eq('kullaniciid', UserSession.user?['kullaniciid']);
    final aracIdList = araclar.map((e) => e['aracid']).toList();
    if (aracIdList.isEmpty) {
      return [];
    }
    final randevular = await Supabase.instance.client
        .from('randevu')
        .select('*, randevudetay(*, hizmet(hizmetadi))')
        .inFilter('aracid', aracIdList)
        .inFilter('durum', ['Beklemede', 'onaylandi'])
        .order('tarih', ascending: true);
    print("RANDEVULAR => $randevular");
    return randevular;
  }

  Future<void> deleteAppointment(int id) async {
    try {
      await Supabase.instance.client
          .from('randevu')
          .update({'durum': 'iptal'})
          .eq('randevuid', id);

      setState(() {
        appointmentsFuture = getAppointments();
      });

      if (mounted) {
        SnackBarHelper.showSuccess(context, "Randevu iptal edildi.");
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, "İptal işlemi başarısız: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    appointmentsFuture = getAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: appointmentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Bir hata oluştu ${snapshot.error}"));
          }

          final appointments = snapshot.data ?? [];
          if (appointments.isEmpty) {
            return Center(child: Text("Henüz randevu yok"));
          }

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final item = appointments[index];

              return CustomListTileWidget(
                title: "Tarih: ${item['tarih']}",
                subTitle: Text(
                  "Saat: ${item['secilensaat']}\n"
                  "Hizmet: ${item['randevudetay'][0]['hizmet']['hizmetadi']}",
                ),
                onTap: () {},
                trailing: IconButton(
                  onPressed: () {
                    showCancelAppointment(context, "Randevuyu İptal Et", () {
                      deleteAppointment(item['randevuid']);
                      Navigator.pop(context);
                    });
                  },
                  icon: Icon(Icons.more_vert),
                ),
              );
            },
          );
        },
      ),
    );
  }
}