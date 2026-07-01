import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Updated: 2026-07-01 by Kayla
// Change: Migrasi dari ThemeCubit ke ThemeController (GetX)
// Reason: Menggunakan manajemen state reaktif GetX untuk merubah tema secara instan
class ThemeController extends GetxController {
  // .obs membuat variabel ini reaktif
  var isDarkMode = false.obs;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    // GetX dapat merubah tema aplikasi secara langsung tanpa me-rebuild seluruh MaterialApp
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}