import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/constants/app_padding.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/theme/app_colors.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/services/services_details.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_list_tile.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/services/services.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});
  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<ServiceModel> _servicesList = [
    ServiceModel(
      name: "Dış Temizleme",
      description:
          "   Aracın dış kaportası, boyaya zarar vermeyen özel pH dengeli aktif köpükler ve mikro fiber eldivenler kullanılarak titizlikle yıkanır. Jantlarda biriken balata tozları ve inatçı çamur lekeleri özel jant temizleyici ürünlerle tamamen sökülüp atılır. Kurulama işlemi sonrasında camlar ve aynalar lekesiz hale getirilirken, lastikleriniz ilk günkü siyahlığına kavuşması için koruyucu parlatıcılar ile desteklenir.",
      price: "Hizmet Bedeli: 250 TL",
      image: "assets/image/dis_temizleme.png",
    ),
    ServiceModel(
      name: "İç Temizleme",
      description:
          "   Aracınızın iç mekanı, en ince ayrıntısına kadar profesyonel vakumlu makinelerle süpürülür. Paspaslar basınçlı hava ve özel fırçalarla kirden arındırılırken, tüm plastik ve vinil yüzeyler antistatik ve hijyenik solüsyonlarla silinerek toz tutması engellenir. Konsol, kapı panelleri ve vites çevresi gibi dar alanlarda biriken tüm kirler temizlenerek ferah ve yeni gibi bir araç ortamı sunulur.",
      price: "Hizmet Bedeli: 200 TL",
      image: "assets/image/ic_temizleme.png",
    ),
    ServiceModel(
      name: "Klima Filtre Temizliği",
      description:
          "   Sürüş konforunuz ve sağlığınız için klima kanalları ve filtreleri mercek altına alınır. Filtreler sökülerek içinde biriken toz, polen, bakteri ve kötü kokuya sebep olan mikroorganizmalar özel dezenfektan solüsyonlarla tamamen temizlenir. Bu işlem sayesinde klimanızdan gelen havanın kalitesi artırılır, motorun klima yükü hafifletilir ve daha sağlıklı, taze bir hava akışı garanti altına alınır.",
      price: "Hizmet Bedeli: 300 TL",
      image: "assets/image/klima_filtre_temizleme.png",
    ),
    ServiceModel(
      name: "Cilalama",
      description:
          "   Aracınızın boyasını güneşin zararlı UV ışınlarından, asit yağmurlarından ve dış etkenlerden korumak için yüksek kaliteli cila uygulaması yapılır. Yüzeydeki kılcal çizikler doldurulurken, boyanın rengi canlandırılır ve derin bir parlaklık kazandırılır. Uygulama sonrasında kaporta üzerinde oluşan su itici katman sayesinde aracınız daha geç kirlenir ve çok daha kolay temizlenebilir bir yüzeye sahip olur.",
      price: "Hizmet Bedeli: 600 TL",
      image: "assets/image/araba_cilalama.png",
    ),
    ServiceModel(
      name: "Paspas Temizliği",
      description:
          "   Araç tabanında en çok kirlenen bölge olan paspaslar, araçtan çıkarılarak materyaline uygun temizlik işlemine tabi tutulur. Kauçuk paspaslar basınçlı su ve kir sökücülerle yıkanırken, halı paspaslar derinlemesine vakumlanıp özel fırçalarla lekelerden arındırılır. Kurutma işlemi sonrasında paspaslarınız hijyenik bir şekilde yerine yerleştirilerek araç tabanındaki tozun havaya karışması engellenmiş olur.",
      price: "Hizmet Bedeli: 100 TL",
      image: "assets/image/paspas_temizleme.png",
    ),
    ServiceModel(
      name: "Koltuk Temizleme",
      description:
          "   Araç koltukları, döşeme tipine (kumaş veya deri) uygun derinlemesine yıkama ve buharlı temizlik aşamalarından geçer. Koltuk dokusunun içine nüfuz etmiş lekeler, ter izleri ve kötü kokular profesyonel leke çıkarıcılar ve güçlü vakum cihazları yardımıyla tamamen ortadan kaldırılır. İşlem sonunda koltuklarınız sadece yüzeyde değil, derinlemesine sterilize edilir ve aracınızın iç estetiği en üst seviyeye taşınır.",
      price: "Hizmet Bedeli: 1000 TL",
      image: "assets/image/arac_koltuk_yikama.png",
    ),
    ServiceModel(
      name: "Pas Temizleme",
      description:
          "   Aracın metal aksamlarında zamanla oluşan ve metalin ömrünü kısaltan paslanmış bölgeler profesyonel müdahale ile temizlenir. Pas sökücü kimyasallar ve hassas yüzey temizleme aparatları kullanılarak metalin altındaki sağlıklı katman korunur. Temizlik sonrasında pasın yayılmasını önleyici koruyucu katmanlar uygulanarak aracınızın yapısal bütünlüğü ve görsel kalitesi uzun vadeli olarak güvence altına alınır.",
      price: "Hizmet Bedeli: 400 TL",
      image: "assets/image/pas_temizleme.png",
    ),
  ];
  List<ServiceModel> filtredServicesList = [];
  @override
  void initState() {
    super.initState();
    filtredServicesList = _servicesList;
  }

  void _filterServices(String value) {
    setState(() {
      filtredServicesList = _servicesList
          .where((a) => a.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Hizmetler Ekranı")),
      body: ListView(
        children: [
          Padding(
            padding: ScreenPadding.smallPadding,
            child: TextField(
              onChanged: (value) {
                //buraya bak
                _filterServices(value);
              },
              maxLength: 25,
              decoration: InputDecoration(
                hintText: "Hizmet ara ...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              controller: _searchController,
            ),
          ),
          ...filtredServicesList //3 nokta (...) koymak demek listedeki elemanlari tek tek disari cikarmak demektir
              .map(
                (a) => CustomListTileWidget(
                  title: a.name,
                  subTitle: Text(a.price),
                  onTap: () {
                    _searchController.clear();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ServicesDetailsScreen(service: a);
                        },
                      ),
                    );
                  },
                ),
              ),
        ],
      ),
    );
  }
}
