import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/constants/app_padding.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/colors/app_colors.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/utils/snackbar_helper.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/home/home_screen.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_elevated_button.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_list_tile.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_text_field.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/form_label.dart';

class CreateAppointmentScreen extends StatefulWidget {
  const CreateAppointmentScreen({super.key});
  @override
  State<CreateAppointmentScreen> createState() =>
      _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState extends State<CreateAppointmentScreen> {
  bool isLoading = false;
  String? selectedService;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  TextEditingController markaController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController numberPlateController = TextEditingController();
  final List<String> services = [
    "İç Yıkama",
    "Dış Yıkama",
    "Klima Filtre Temizleme",
    "Araç Cilalama",
    "Paspas Temizleme",
    "Araç Koltuk Yıkama",
    "Araçta Pas Temizleme",
  ];
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
  }

  //
  Future<void> CreateAppointment() async {
    String marka = markaController.text.trim();
    String model = modelController.text.trim();
    String type = typeController.text.trim();
    String numberPlate = numberPlateController.text.trim();

    setState(() {
      isLoading = true;
    });
    await Future.delayed(Duration(seconds: 2));
    if (selectedService == null) {
      SnackBarHelper.showError(context, "Lütfen Bir Hizmet Seçin!");
      setState(() {
        isLoading = false;
      });
      return;
    }
    if (selectedDate == null) {
      SnackBarHelper.showError(context, "Lütfen tarih seçin!");
      setState(() {
        isLoading = false;
      });
      return;
    }
    if (selectedTime == null) {
      SnackBarHelper.showError(context, "Lütfen bir saat seçin!");
      setState(() {
        isLoading = false;
      });
      return;
    }
    if (marka.isEmpty || model.isEmpty || type.isEmpty || numberPlate.isEmpty) {
      SnackBarHelper.showError(context, "Lütfen tüm alanları doldurun!");
      setState(() {
        isLoading = false;
      });
      return;
    }
    //Randevunun Basarili oldugunu gosteren Dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          iconColor: AppColors.green,
          icon: Icon(Icons.check),
          backgroundColor: AppColors.blueGrey,
          title: Text("Başarılı", textAlign: TextAlign.start),
          content: Text("Randevunuz oluşturuldu"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return HomeScreen();
                    },
                  ),
                );
              },
              child: Text(
                "Ana Sayfaya Dön",
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        );
      },
    );
    setState(() {
      isLoading = false;
    });
  }

  //Ram bellek sismesin diye yaptim
  @override
  void dispose() {
    markaController.dispose();
    modelController.dispose();
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
              title: selectedService ?? "Hizmet Seç",
              subTitle: Text(""),
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: Colors.blueGrey[100],
                  context: context,
                  builder: (context) {
                    return ListView.builder(
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(services[index]),
                          onTap: () {
                            setState(() {
                              selectedService = services[index];
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
                    return ListView.builder(
                      itemCount: availableTimes.length,
                      itemBuilder: (context, index) {
                        final time = availableTimes[index];
                        return ListTile(
                          title: Text(
                            "${time.hour.toString().padLeft(2, "0")}:${time.minute.toString().padLeft(2, "0")}",
                          ),
                          onTap: () {
                            setState(() {
                              selectedTime = availableTimes[index];
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
            FormLabel(label: "Aracınızın Markasını Giriniz:"),
            CustomTextField(
              hintText: "Aracınızın Markası",
              labelText: "",
              isPassword: false,
              icon: Icon(Icons.add),
              controller: markaController,
            ),
            FormLabel(label: "Aracınızın Modelini Giriniz:"),
            CustomTextField(
              hintText: "Aracınızın modeli",
              labelText: "",
              isPassword: false,
              icon: Icon(Icons.add),
              controller: modelController,
            ),
            FormLabel(label: "Aracınızın Türünü Giriniz:"),
            CustomTextField(
              hintText: "Aracınızın Türü(Binek araç vb.)",
              labelText: "",
              isPassword: false,
              icon: Icon(Icons.add),
              controller: typeController,
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
                    onPressed: () {
                      CreateAppointment();
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
