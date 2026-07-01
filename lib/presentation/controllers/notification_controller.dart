import 'package:get/get.dart';

class NotificationItem {
  final String message;
  final DateTime timestamp;
  NotificationItem({required this.message, required this.timestamp});
}

// Updated: 2026-07-01 by Kayla
// Change: Migrasi dari NotificationCubit ke NotificationController
// Reason: Menyederhanakan penambahan data riwayat notifikasi tanpa perlu menginisialisasi file State terpisah
class NotificationController extends GetxController {
  var items = <NotificationItem>[].obs;
  var unreadCount = 0.obs;

  void addNotification(String message) {
    final newItem = NotificationItem(message: message, timestamp: DateTime.now());
    items.insert(0, newItem);
    unreadCount.value++;
  }

  void markAsRead() {
    unreadCount.value = 0;
  }
}