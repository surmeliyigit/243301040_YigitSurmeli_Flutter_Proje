import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/constants/app_padding.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/colors/app_colors.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/utils/snackbar_helper.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/services/services_details.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_list_tile.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/services/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});
  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  List<ServiceModel> servicesList = [];
  List<ServiceModel> filteredServicesList = [];
  String getServiceImage(String name) {
    switch (name) {
      case "Dış Temizleme":
        return "assets/image/dis_temizleme.png";
      case "İç Temizleme":
        return "assets/image/ic_temizleme.png";
      case "Cilalama":
        return "assets/image/araba_cilalama.png";
      case "Koltuk Temizleme":
        return "assets/image/arac_koltuk_yikama.png";
      case "Klima Filtre Temizliği":
        return "assets/image/klima_filtre_temizleme.png";
      case "Pas Temizleme":
        return "assets/image/pas_temizleme.png";
      case "Paspas Temizliği":
        return "assets/image/paspas_temizleme.png";
      default:
        return "assets/oto_yikama_logo.png";
    }
  }

  Future<void> fetchServices() async {
    try {
      final data = await Supabase.instance.client.from('hizmet').select();

      final list = (data as List).map((e) {
        final name = e['hizmetadi'];

        return ServiceModel(
          name: name,
          description: e['aciklama'] ?? "Açıklama bulunamadı",
          price: "Hizmet Bedeli: ${e['listefiyati'] ?? 0} TL",
          image: getServiceImage(name),
        );
      }).toList();

      setState(() {
        servicesList = list;
        filteredServicesList = list;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        SnackBarHelper.showError(context, "Hizmetler yüklenemedi: $e");
      }
    }
  }

  List<ServiceModel> filtredServicesList = [];
  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  String normalize(String text) {
    return text
        .toLowerCase()
        .replaceAll('ı', 'i')
        .replaceAll('İ', 'i')
        .replaceAll('I', 'i')
        .replaceAll('U', 'ü')
        .replaceAll('u', 'ü');
  }

  void _filterServices(String value) async {
    final search = normalize(value);
    final data = await Supabase.instance.client.from('hizmet').select();
    final list = (data as List)
        .where((e) {
          final name = normalize(e['hizmetadi']);
          return name.contains(search);
        })
        .map((e) {
          final name = e['hizmetadi'];

          return ServiceModel(
            name: name,
            description: e['aciklama'] ?? "Açıklama bulunamadı",
            price: "Hizmet Bedeli: ${e['listefiyati'] ?? 0} TL",
            image: getServiceImage(name),
          );
        })
        .toList();

    setState(() {
      filteredServicesList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Padding(
                  padding: ScreenPadding.smallPadding,
                  child: TextField(
                    onChanged: (value) {
                      //buraya bak
                      _filterServices(value);
                    },
                    maxLength: 30,
                    decoration: InputDecoration(
                      hintText: "Hizmet ara ...",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    controller: _searchController,
                  ),
                ),
                ...(filteredServicesList.isEmpty
                    ? [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Center(child: Text("Hizmet bulunamadı")),
                        ),
                      ]
                    : filteredServicesList
                          .map(
                            (a) => CustomListTileWidget(
                              title: a.name,
                              subTitle: Text(a.price),
                              onTap: () {},
                              trailing: IconButton(
                                icon: Icon(Icons.chevron_right),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return ServicesDetailsScreen(
                                          service: a,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                          .toList()),
              ],
            ),
    );
  }
}
