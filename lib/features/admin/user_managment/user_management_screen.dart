import 'package:flutter/material.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/core/constants/app_padding.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_elevated_button.dart';
import 'package:oto_yikama_randevu_hizmet_sistemi/features/widgets/custom_list_tile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  List users = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    setState(() => isLoading = true);

    final response = await Supabase.instance.client
        .from('kullanici')
        .select()
        .eq('durum', 'pasif');

    setState(() {
      users = response;
      isLoading = false;
    });
  }

  Future<void> activateUser(int id) async {
    await Supabase.instance.client
        .from('kullanici')
        .update({'durum': 'aktif'})
        .eq('kullaniciid', id);

    await loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aktivasyon Talepleri"),
        actions: [
          IconButton(onPressed: loadUsers, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
          ? const Center(child: Text("Aktif edilmesi gereken kullanıcı yok"))
          : Padding(
              padding: ScreenPadding.mediumPadding,
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];

                  return CustomListTileWidget(
                    title: user['ad'] ?? "",
                    subTitle: Text(user['eposta'] ?? ""),
                    onTap: () {},
                    trailing: CustomElevatedButton(
                      title: "Aktif Et",
                      onPressed: () => activateUser(user['kullaniciid']),
                    ),
                    leading: Icon(Icons.account_circle),
                  );
                },
              ),
            ),
    );
  }
}
// ListTile(
//                   title: Text(user['ad'] ?? ''),
//                   subtitle: Text(user['eposta'] ?? ''),
//                   trailing: ElevatedButton(
//                     onPressed: () => activateUser(user['kullaniciid']),
//                     child: const Text("Aktif Et"),
//                   ),
//                 );