import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'data/services/api_service.dart';
import 'presentation/controllers/user_controller.dart';
import 'presentation/controllers/notification_controller.dart';
import 'presentation/controllers/theme_controller.dart';
import 'presentation/pages/splash_page.dart';

void main() {
// Updated: 2026-07-01 by Kayla
// Change: Inisialisasi Dependency Injection GetX
// Reason: Menggantikan RepositoryProvider dan MultiBlocProvider yang boros kode
  Get.put(ThemeController());
  Get.put(NotificationController());
  Get.put(UserController(apiService: ApiService()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
// Updated: 2026-07-01 by Kayla
// Change: Mengubah MaterialApp menjadi GetMaterialApp
// Reason: Agar fungsi Get.to(), Get.snackbar(), dan Get.changeThemeMode() berfungsi
    return GetMaterialApp(
      title: 'GitHub Mini App',
      themeMode: ThemeMode.light, // ThemeMode diatur oleh Get.changeThemeMode() nanti
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue,
          brightness: Brightness.light,
          surface: const Color(0xFFF8F9FA),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          centerTitle: true,
        ),
        cardColor: Colors.white,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue,
          brightness: Brightness.dark,
          surface: const Color(0xFF121212),
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        cardColor: const Color(0xFF1E1E1E),
      ),
      home: const SplashPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}