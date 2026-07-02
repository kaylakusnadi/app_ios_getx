import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../widgets/user_card_widget.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userC = Get.find<UserController>();

// Updated: 2026-07-01 by Kayla
// Change: Menggunakan Obx widget bawaan GetX
    return Obx(() {
      if (userC.favoriteUsers.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("👏", style: TextStyle(fontSize: 48)),
              const SizedBox(height: 20),
              const Text("Yeay, Data Favorit Kosong", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text("Silahkan Refresh Page untuk memperbarui data", style: TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 28),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                onPressed: () {
// Updated: 2026-07-01 by Kayla
// Change: Menggunakan Get.snackbar untuk pemanggilan popup tanpa context
                  Get.snackbar(
                    "Informasi", 
                    "Sistem telah direfresh. Belum ada data yang difavoritkan.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.black87,
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(16),
                  );
                },
                child: const Text("Refresh", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        );
      }

      final listToShow = userC.searchQuery.value.isEmpty 
          ? userC.favoriteUsers 
          : userC.favoriteUsers.where((u) => u.login.toLowerCase().contains(userC.searchQuery.value.toLowerCase())).toList();

      if (listToShow.isEmpty) {
        return const Center(
          child: Text("Tidak ada hasil pencarian di Favorit.", style: TextStyle(color: Colors.grey, fontSize: 16)),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.only(top: 12.0, bottom: 24.0),
        itemCount: listToShow.length,
        itemBuilder: (context, index) {
          return UserCardWidget(user: listToShow[index], isFavorite: true);
        },
      );
    });
  }
}