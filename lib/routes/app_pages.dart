import 'package:get/get.dart';
import 'app_routes.dart';
import '../presentation/pages/splash_page.dart';
import '../presentation/pages/dashboard_page.dart';
import '../presentation/pages/user_detail_page.dart';
import '../presentation/pages/notification_page.dart';
import '../bindings/dashboard_binding.dart';

// Updated: 2026-07-02 by Kayla
// Change: Membuat konfigurasi GetPage
// Reason: Implementasi GetX Routing sesuai AC RND-150 untuk memetakan rute ke halaman dan binding-nya
class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () => const DashboardPage(),
      binding: DashboardBinding(), // Inject dependency saat masuk halaman ini
    ),
    GetPage(
      name: AppRoutes.DETAIL,
      page: () => const UserDetailPage(),
    ),
    GetPage(
      name: AppRoutes.NOTIFICATION,
      page: () => const NotificationPage(),
    ),
  ];
}