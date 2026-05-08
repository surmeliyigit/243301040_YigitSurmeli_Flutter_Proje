import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/colors/app_colors.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/constants/app_padding.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/utils/snackbar_helper.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_bottom_sheet.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_elevated_button.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_list_tile.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_sheet_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminServicesScreen extends StatefulWidget {
  const AdminServicesScreen({super.key});

  @override
  State<AdminServicesScreen> createState() => _AdminServicesScreenState();
}

class _AdminServicesScreenState extends State<AdminServicesScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController describeController = TextEditingController();
  List services = [];
  Future<void> loadServices() async {
    final response = await Supabase.instance.client.from('hizmet').select();
    setState(() {
      services = response;
    });
  }

  Future<void> addService() async {
    final name = nameController.text.trim();
    final timeText = timeController.text.trim();
    final priceText = priceController.text.trim();

    if (name.isEmpty || timeText.isEmpty || priceText.isEmpty) {
      throw "Tüm alanları doldurunuz!";
    }

    final int? time = int.tryParse(timeText);
    final double? price = double.tryParse(priceText);

    if (time == null) {
      throw "Hizmet süresi sadece sayı olmalıdır!";
    }

    if (price == null) {
      throw "Hizmet fiyatı sadece sayı olmalıdır!";
    }

    await Supabase.instance.client.from('hizmet').insert({
      'hizmetadi': name,
      'listefiyati': price,
      'hizmetsuresi': time,
    });

    await loadServices();
    nameController.clear();
    priceController.clear();
    timeController.clear();
  }

  Future<void> deleteService(int id) async {
    await Supabase.instance.client.from('hizmet').delete().eq('hizmetid', id);
    await loadServices();
  }

  @override
  void initState() {
    super.initState();
    loadServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hizmetleri Düzenle"), centerTitle: false),
      body: Padding(
        padding: ScreenPadding.mediumPadding,
        child: ListView.builder(
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            return CustomListTileWidget(
              title: service['hizmetadi'],
              subTitle: Text(
                "Hizmet fiyatı: ${service['listefiyati'] ?? "0"} TL\n"
                "Hizmet Süresi: ${service['hizmetsuresi'] ?? "0"}dk ",
              ),
              trailing: IconButton(
                onPressed: () {
                  showCancelAppointment(context, "Hizmeti Sil", () async {
                    deleteService(service['hizmetid']);
                    Navigator.of(context).pop();
                    await loadServices();
                  });
                },
                icon: Icon(Icons.more_vert),
              ),
              onTap: () {},
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, //buna bak
        backgroundColor: AppColors.lightBlue,
        items: [
          BottomNavigationBarItem(icon: SizedBox(), label: ""),
          BottomNavigationBarItem(icon: SizedBox(), label: ""),
          BottomNavigationBarItem(icon: SizedBox(), label: ""),
          BottomNavigationBarItem(icon: SizedBox(), label: ""),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 80,
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              showDragHandle: true,
              backgroundColor: AppColors.blueGrey,
              context: context,
              builder: (context) {
                bool isLoadingSheet = false;
                return StatefulBuilder(
                  builder: (context, setStateSheet) {
                    return ListView(
                      children: [
                        CustomSheetTextField(
                          hintText: "Hizmet adı",
                          controller: nameController,
                          isPassword: false,
                          icon: Icon(Icons.cleaning_services),
                          isDescribeController: false,
                        ),
                        CustomSheetTextField(
                          hintText: "Hizmet Açiklaması",
                          controller: describeController,
                          isPassword: false,
                          icon: Icon(Icons.cleaning_services),
                          isDescribeController: true,
                        ),
                        CustomSheetTextField(
                          hintText: "Hizmet Süresi(dakika olarak)",
                          controller: timeController,
                          isPassword: false,
                          icon: Icon(Icons.cleaning_services),
                          isDescribeController: false,
                        ),
                        CustomSheetTextField(
                          hintText: "Hizmet fiyatı",
                          controller: priceController,
                          isPassword: false,
                          icon: Icon(Icons.cleaning_services),
                          isDescribeController: false,
                        ),
                        Center(
                          child: isLoadingSheet
                              ? CircularProgressIndicator()
                              : CustomElevatedButton(
                                  title: "Hizmeti Ekle",
                                  onPressed: () async {
                                    setStateSheet(() {
                                      isLoadingSheet = true;
                                    });

                                    try {
                                      await addService();
                                      Navigator.of(context).pop();
                                      SnackBarHelper.showSuccess(
                                        context,
                                        "Hizmet eklendi",
                                      );
                                    } catch (e) {
                                      Navigator.of(context).pop();
                                      SnackBarHelper.showError(
                                        context,
                                        e.toString(),
                                      );
                                    }
                                    setStateSheet(() {
                                      isLoadingSheet = false;
                                    });
                                  },
                                  buttonBackground: AppColors.primary,
                                ),
                        ),
                        SizedBox(height: 20),
                      ],
                    );
                  },
                );
              },
            );
          },
          backgroundColor: AppColors.secondary,
          child: Text(
            "Hizmet Ekle",
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
