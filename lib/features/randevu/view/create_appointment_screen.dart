import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/constants/app_padding.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/colors/app_colors.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/data/car_data.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/utils/snackbar_helper.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/auth/users/user_data.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/home/home_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_elevated_button.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_list_tile.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_text_field.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/form_label.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateAppointmentScreen extends StatefulWidget {
  const CreateAppointmentScreen({super.key});
  @override
  State<CreateAppointmentScreen> createState() =>
      _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState extends State<CreateAppointmentScreen> {
  bool isLoading = false;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  TextEditingController typeController = TextEditingController();
  TextEditingController numberPlateController = TextEditingController();
  String? selectedBrand;
  int? selectedBrandId;
  String? selectedModel;
  String? selectedType;
  int? selectedServiceId;
  String? selectedServiceName;
  String? selectedServicePrice;
  int? selectedAracId;
  int? selectedModelId;
  List<Map<String, dynamic>> services = [];
  List<Map<String, dynamic>> brands = [];
  List<Map<String, dynamic>> models = [];
  List<TimeOfDay> bookedTimes = [];
  final List<TimeOfDay> availableTimes = [
    TimeOfDay(hour: 9, minute: 0),
    TimeOfDay(hour: 10, minute: 0),
    TimeOfDay(hour: 11, minute: 0),
    TimeOfDay(hour: 12, minute: 0),
    TimeOfDay(hour: 14, minute: 0),
    TimeOfDay(hour: 15, minute: 0),
    TimeOfDay(hour: 16, minute: 0),
    TimeOfDay(hour: 17, minute: 0),
    TimeOfDay(hour: 18, minute: 0),
    TimeOfDay(hour: 19, minute: 0),
    TimeOfDay(hour: 20, minute: 0),
  ];

  Future<void> pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );

    if (date != null) {
      //buna bak
      setState(() {
        selectedDate = date;
      });
    }
    await fetchBookedTimes();
  }

  Future<void> fetchBrands() async {
    final data = await Supabase.instance.client.from('markalar').select();
    print("BRANDS: $data");
    setState(() {
      brands = List<Map<String, dynamic>>.from(data);
    });
  }

  Future<void> fetchModels(int markaId) async {
    final data = await Supabase.instance.client
        .from('modeller')
        .select()
        .eq('markaid', markaId);
    print("MODELLER: $data");
    setState(() {
      models = List<Map<String, dynamic>>.from(data);
    });
  }

  Future<void> selectBrand() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      backgroundColor: AppColors.blueGrey,
      context: context,
      builder: (context) {
        return SelectionBottomSheet(items: brands, titleKey: 'marka');
      },
    );

    if (result != null) {
      setState(() {
        selectedBrand = result['marka'];
        selectedBrandId = result['markaid'];
        selectedModel = null;
      });
    }
  }

  Future<void> selectModel(int markaId) async {
    final data = await Supabase.instance.client
        .from('modeller')
        .select()
        .eq('markaid', markaId);

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      backgroundColor: AppColors.blueGrey,
      context: context,
      builder: (context) {
        return SelectionBottomSheet(
          items: List<Map<String, dynamic>>.from(data),
          titleKey: 'modeladi',
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedModel = result['modeladi'];
        selectedModelId = result['modelid'];
      });
    }
  }

  Future<int> createOrGetAracId() async {
    final plaka = numberPlateController.text.trim();

    final existing = await Supabase.instance.client
        .from('araclar')
        .select('aracid')
        .eq('plaka', plaka)
        .maybeSingle();

    if (existing != null) {
      return existing['aracid'];
    }

    final inserted = await Supabase.instance.client
        .from('araclar')
        .insert({
          'kullaniciid': UserSession.user?['kullaniciid'],
          'modelid': selectedModelId,
          'plaka': plaka,
        })
        .select('aracid')
        .single();

    return inserted['aracid'];
  }

  Future<void> selectService() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      backgroundColor: AppColors.blueGrey,
      builder: (context) {
        return SelectionBottomSheet(items: services, titleKey: 'hizmetadi');
      },
    );

    if (result != null) {
      setState(() {
        selectedServiceId = result['hizmetid'];
        selectedServiceName = result['hizmetadi'];
        selectedServicePrice = result['listeFiyati'].toString();
      });
    }
  }

  Future<void> fetchServices() async {
    final data = await Supabase.instance.client.from('hizmet').select();
    print("SERVICES: $data");
    setState(() {
      services = List<Map<String, dynamic>>.from(data);
    });
  }

  Future<void> createAppointment() async {
    setState(() => isLoading = true);

    if (selectedServiceId == null ||
        selectedDate == null ||
        selectedTime == null ||
        selectedBrandId == null ||
        selectedModelId == null ||
        numberPlateController.text.trim().isEmpty) {
      setState(() => isLoading = false);
      SnackBarHelper.showError(context, "Tüm alanları doldur");
      return;
    }

    try {
      final aracId = await createOrGetAracId();

      await Supabase.instance.client.rpc(
        'randevu_olustur_ve_detaylandir',
        params: {
          'p_aracid': aracId,
          'p_tarih': selectedDate!.toIso8601String().split('T')[0],
          'p_saat':
              '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}:00',
          'p_hizmetid': selectedServiceId,
        },
      );

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: AppColors.blueGrey,
          title: Text("Başarılı"),
          content: Text("Randevu ve detayları başarıyla oluşturuldu."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => HomeScreen()),
                  (roote) => false,
                );
              },
              child: Text("Tamam"),
            ),
          ],
        ),
      );
    } catch (e) {
      SnackBarHelper.showError(context, "İşlem başarısız: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchBookedTimes() async {
    if (selectedDate == null) return;

    final response = await Supabase.instance.client
        .from('randevu')
        .select('secilensaat')
        .eq('tarih', selectedDate!.toIso8601String().split('T')[0]);

    bookedTimes = (response as List).map((item) {
      final time = item['secilensaat'];

      final parts = time.split(":");
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }).toList();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchBrands();
    fetchServices();
  }

  //Ram bellek sismesin diye yaptim
  @override
  void dispose() {
    typeController.dispose();
    numberPlateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: Text("Randevu Oluştur")),
      body: Padding(
        padding: ScreenPadding.mediumPadding,
        child: ListView(
          children: [
            CustomListTileWidget(
              title: selectedServiceName ?? "Hizmet Seç",
              subTitle: Text(""),
              onTap: () {
                selectService();
              },
            ),
            SizedBox(height: 20),
            CustomListTileWidget(
              leading: Icon(Icons.calendar_month),
              title: selectedDate == null
                  ? "Tarih Seç"
                  : "${selectedDate!.day.toString().padLeft(2, "0")}/${selectedDate!.month.toString().padLeft(2, "0")}/${selectedDate!.year.toString().padLeft(2, "0")}",
              subTitle: Text(""),
              onTap: pickDate,
            ),
            SizedBox(height: 20),
            CustomListTileWidget(
              leading: Icon(Icons.access_time),
              title: selectedTime == null
                  ? "Saat Seç"
                  : "${selectedTime!.hour.toString().padLeft(2, "0")}.${selectedTime!.minute.toString().padLeft(2, "0")}",
              subTitle: Text(""),
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: AppColors.blueGrey,
                  context: context,
                  builder: (context) {
                    final availableFilteredTimes = availableTimes.where((time) {
                      return !bookedTimes.any(
                        (b) => b.hour == time.hour && b.minute == time.minute,
                      );
                    }).toList();
                    return ListView.builder(
                      itemCount: availableFilteredTimes.length,
                      itemBuilder: (context, index) {
                        final time = availableFilteredTimes[index];
                        return ListTile(
                          title: Text(
                            "${time.hour.toString().padLeft(2, "0")}:${time.minute.toString().padLeft(2, "0")}",
                          ),
                          onTap: () {
                            setState(() {
                              selectedTime = time;
                            });
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
            SizedBox(height: 20),
            CustomListTileWidget(
              title: selectedBrand ?? "Marka Seç",
              subTitle: const Text(""),
              onTap: selectBrand,
            ),
            SizedBox(height: 20),
            CustomListTileWidget(
              title: selectedModel ?? "Model Seç",
              subTitle: const Text(""),
              onTap: () {
                if (selectedBrandId == null) {
                  SnackBarHelper.showError(context, "Önce marka seçmelisin");
                  return;
                }

                selectModel(selectedBrandId!);
              },
            ),
            FormLabel(label: "Aracınızın Plakasını Giriniz:"),
            CustomTextField(
              hintText: "Aracınızın Plakası",
              labelText: "",
              isPassword: false,
              icon: Icon(Icons.add),
              controller: numberPlateController,
            ),

            isLoading
                ? Center(child: CircularProgressIndicator())
                : CustomElevatedButton(
                    title: "Randevu Oluştur",
                    onPressed: () async {
                      createAppointment();
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

class SelectionBottomSheet extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final String titleKey;

  const SelectionBottomSheet({
    super.key,
    required this.items,
    required this.titleKey,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text("Veri bulunamadı"),
        ),
      );
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return ListTile(
          title: Text(item[titleKey]?.toString() ?? "-"),
          onTap: () {
            Navigator.pop(context, item);
          },
        );
      },
    );
  }
}
