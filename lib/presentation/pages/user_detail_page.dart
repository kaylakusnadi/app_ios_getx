import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../controllers/notification_controller.dart';

class UserDetailPage extends StatefulWidget {
  final String username;
  const UserDetailPage({Key? key, required this.username}) : super(key: key);

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final userC = Get.find<UserController>();
  final notifC = Get.find<NotificationController>();

  @override
  void initState() {
    super.initState();
    // Gunakan Future.microtask agar aman jika men-trigger state change di GetX saat build
    Future.microtask(() => userC.fetchUserDetail(widget.username));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail User"),
        actions: [
// Updated: 2026-07-01 by Kayla
// Change: Memantau perubahan nilai detailUser dan favoriteUsers secara reaktif
          Obx(() {
            if (userC.detailUser.value == null) return const SizedBox();
            
            final isFav = userC.favoriteUsers.any((element) => element.login == userC.detailUser.value!.login);
            return IconButton(
              icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.red),
              onPressed: () {
                userC.toggleFavorite(userC.detailUser.value!);
                
                final rawMessage = isFav 
                    ? "Menghapus |${userC.detailUser.value!.login}| dari favorit" 
                    : "Berhasil menambahkan |${userC.detailUser.value!.login}| ke favorit";
                
// Updated: 2026-07-01 by Kayla
// Change: Memanggil Get.snackbar tanpa bergantung pada BuildContext
                Get.snackbar(
                  "Sukses", 
                  rawMessage.replaceAll('|', ''),
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: isDark ? Colors.grey.shade900 : Colors.black87,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                );
                
                notifC.addNotification(rawMessage);
              },
            );
          })
        ],
      ),
      body: Obx(() {
        if (userC.isDetailLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (userC.detailError.value != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Gagal memuat detail: ${userC.detailError.value}"),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => userC.fetchUserDetail(widget.username),
                  child: const Text("Retry"),
                )
              ],
            ),
          );
        }
        if (userC.detailUser.value == null) return const SizedBox();

        final user = userC.detailUser.value!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: user.login,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                  backgroundImage: NetworkImage(user.avatarUrl),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user.login,
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(24.0),
                  border: Border.all(color: isDark ? Colors.white12 : Colors.white, width: 1.5),
                  boxShadow: [
                    BoxShadow(color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.04), blurRadius: 20.0, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    _buildDetailTile(context, Icons.person_outline, "Name", user.name),
                    const Divider(height: 24),
                    _buildDetailTile(context, Icons.email_outlined, "E-Mail", user.email),
                    const Divider(height: 24),
                    _buildDetailTile(context, Icons.location_on_outlined, "Location", user.location),
                    const Divider(height: 24),
                    _buildDetailTile(context, Icons.business_outlined, "Company", user.company),
                    const Divider(height: 24),
                    _buildDetailTile(context, Icons.people_alt_outlined, "Followers", user.followers.toString()),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDetailTile(BuildContext context, IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blue.shade300, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 4),
              Text(
                value.isNotEmpty ? value : "-",
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.w600, 
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}