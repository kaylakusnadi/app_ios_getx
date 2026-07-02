import 'package:get/get.dart';
import '../data/services/api_service.dart';
import '../presentation/controllers/theme_controller.dart';
import '../presentation/controllers/notification_controller.dart';

// Updated: 2026-07-02 by Kayla
// Change: Membuat InitialBinding
// Reason: Mengatur injeksi dependensi global (Service, Theme, Notification) yang hidup selama aplikasi berjalan
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiService(), permanent: true);
    Get.put(ThemeController(), permanent: true);
    Get.put(NotificationController(), permanent: true);
  }
}