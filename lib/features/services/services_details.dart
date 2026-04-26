import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/constants/app_padding.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/services/services.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_elevated_button.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_image_card.dart';

class ServicesDetailsScreen extends StatefulWidget {
  ServicesDetailsScreen({super.key, required this.service});
  final String title = "Hizmet Detay Ekranı";
  final ServiceModel service;
  TextEditingController searchController=TextEditingController();

  @override
  State<ServicesDetailsScreen> createState() => _ServicesDetailsScreenState();
}

class _ServicesDetailsScreenState extends State<ServicesDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: ScreenPadding.mediumPadding,
        child: ListView(
          children: [
            CustomImageCard(imagePath: widget.service.image),
            Text(
              widget.service.name,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              widget.service.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              widget.service.price,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: ScreenPadding.largePadding,
              child: CustomElevatedButton(
                title: "Randevu Oluştur",
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
