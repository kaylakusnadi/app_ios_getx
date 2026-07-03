import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../controllers/theme_controller.dart';
import '../controllers/notification_controller.dart';
import '../../routes/app_routes.dart';
import '../widgets/user_card_widget.dart';
import 'favorite_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ScrollController _scrollController = ScrollController();
// Updated: 2026-07-01 by Kayla
// Change: Mengakses Controllers via Get.find()
// Reason: Standarisasi dependency injection GetX di layer UI
  final userC = Get.find<UserController>();
  final themeC = Get.find<ThemeController>();
  final notifC = Get.find<NotificationController>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      userC.fetchUserList();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("GitHub Explorer", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
          actions: [
// Updated: 2026-07-01 by Kayla
// Change: Mengganti BlocBuilder dengan Obx untuk reaktivitas tema
// Reason: Menggunakan reaktivitas GetX agar perubahan tema instan tanpa merender ulang seluruh komponen
            Obx(() => IconButton(
              icon: Icon(themeC.isDarkMode.value ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
              onPressed: () => themeC.toggleTheme(),
            )),
            Obx(() => Stack(
              alignment: Alignment.center,
              children: [
// Updated: 2026-07-02 by Kayla
// Change: Navigasi menggunakan Named Route (AppRoutes)
// Reason: Mematuhi AC RND-150 untuk standarisasi GetX Routing
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded),
                  onPressed: () {
// Updated: 2026-07-03 by Kayla
// Change: Menambahkan perintah unfocus sebelum pindah halaman
// Reason: Mencegah bug UI di mana keyboard otomatis muncul kembali saat user melakukan 'back' dari halaman riwayat notifikasi
                    FocusManager.instance.primaryFocus?.unfocus();
                    Get.toNamed(AppRoutes.NOTIFICATION);
                  },
                ),
                if (notifC.unreadCount.value > 0)
                  Positioned(
                    right: 8,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        '${notifC.unreadCount.value}',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            )),
          ],
          bottom: const TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            indicatorWeight: 3.0,
            tabs: [
              Tab(icon: Icon(Icons.people_outline), text: "Popular"),
              Tab(icon: Icon(Icons.favorite_outline), text: "Favorite"),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) => userC.searchUsers(value),
// Updated: 2026-07-03 by Kayla
// Change: Menambahkan aksi onTapOutside pada TextField
// Reason: Otomatis menutup keyboard ketika user melakukan klik/tap di luar area pencarian (seperti menekan tombol favorite di card)
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  hintText: "Cari user...",
                  prefixIcon: const Icon(Icons.search, color: Colors.blue),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.blue, width: 2)),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
// Updated: 2026-07-01 by Kayla
// Change: Mengganti BlocBuilder dengan Obx untuk performa yang lebih cepat di tab Popular
// Reason: Obx hanya merebuild widget yang state-nya berubah secara spesifik
                  Obx(() {
                    final listToShow = userC.searchResult.value ?? userC.users;
                    
                    if (userC.isUsersLoading.value && userC.users.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (userC.usersError.value != null && userC.users.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Error: ${userC.usersError.value}", style: const TextStyle(color: Colors.red)),
                            ElevatedButton(
                              onPressed: () => userC.fetchUserList(isRefresh: true),
                              child: const Text("Retry"),
                            )
                          ],
                        ),
                      );
                    }

                    if (listToShow.isEmpty) {
                      return const Center(
                        child: Text("Tidak ada hasil pencarian di Popular.", style: TextStyle(color: Colors.grey, fontSize: 16)),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async => await userC.fetchUserList(isRefresh: true),
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
// Updated: 2026-07-03 by Kayla
// Change: Menambahkan properti keyboardDismissBehavior pada ListView
// Reason: Meningkatkan UX dengan menutup keyboard secara otomatis ketika pengguna mulai melakukan scroll pada daftar
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: const EdgeInsets.only(top: 12.0, bottom: 24.0),
                        itemCount: (userC.searchResult.value != null || userC.hasReachedMax) 
                            ? listToShow.length 
                            : listToShow.length + 1,
                        itemBuilder: (context, index) {
                          if (index >= listToShow.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          final isFav = userC.favoriteUsers.any((fav) => fav.login == listToShow[index].login);
                          return UserCardWidget(user: listToShow[index], isFavorite: isFav);
                        },
                      ),
                    );
                  }),
                  const FavoritePage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}