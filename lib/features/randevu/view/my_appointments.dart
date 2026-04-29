import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/colors/app_colors.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_elevated_button.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_list_tile.dart';

class MyAppointmentScreen extends StatefulWidget {
  const MyAppointmentScreen({super.key});

  @override
  State<MyAppointmentScreen> createState() => _MyAppointmentScreenState();
}

class _MyAppointmentScreenState extends State<MyAppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          CustomListTileWidget(
            title: "İç Yıkama",
            subTitle: Text("10.08.2026"),
            onTap: () {},
            leading: Icon(Icons.cleaning_services),
            trailing: IconButton(
              onPressed: () {
                showCancelAppointment(context);
              },
              icon: Icon(Icons.more_vert),
            ),

            //PopupMenuButton(
            //   itemBuilder: (context) {
            //     return [
            //       PopupMenuItem(child: Text("İptal Et"), value: "iptal"),
            //     ];
            //   },
            // ),
          ),
          CustomListTileWidget(
            title: "Dış Yıkama",
            subTitle: Text("10.08.2026"),
            onTap: () {},
            leading: Icon(Icons.cleaning_services),
            trailing: IconButton(
              onPressed: () {
                showCancelAppointment(context);
              },
              icon: Icon(Icons.more_vert),
            ),
          ),
          CustomListTileWidget(
            title: "Motor Yıkama",
            subTitle: Text("10.08.2026"),
            onTap: () {},
            leading: Icon(Icons.cleaning_services),
            trailing: IconButton(
              onPressed: () {
                showCancelAppointment(context);
              },
              icon: Icon(Icons.more_vert),
            ),
          ),
          CustomListTileWidget(
            title: "Araç Cilalama",
            subTitle: Text("10.08.2026"),
            onTap: () {},
            leading: Icon(Icons.cleaning_services),
            trailing: IconButton(
              onPressed: () {
                showCancelAppointment(context);
              },
              icon: Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> showCancelAppointment(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: AppColors.blueGrey,
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          width: double.infinity,
          child: Column(
            children: [
              Spacer(),
              CustomElevatedButton(
                title: "Randevuyu İptal Et",
                onPressed: () {},
                buttonBackground: AppColors.cancelColor,
              ),
              Spacer(),
            ],
          ),
        );
      },
    );
  }
}
