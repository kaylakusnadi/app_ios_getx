import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../routes/app_routes.dart';
import '../controllers/user_controller.dart';

class UserCardWidget extends StatelessWidget {
  final UserModel user;
  final bool isFavorite;

  const UserCardWidget({
    Key? key, 
    required this.user, 
    this.isFavorite = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () {
// Updated: 2026-07-02 by Kayla
// Change: Panggil fetch data detail sebelum routing, dan gunakan Get.toNamed
// Reason: Agar halaman detail tetap stateless dan navigasi terpusat
        Get.find<UserController>().fetchUserDetail(user.login);
        Get.toNamed(AppRoutes.DETAIL);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(color: isDark ? Colors.white12 : Colors.white, width: 1.5),
          boxShadow: [
            BoxShadow(color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.06), blurRadius: 24.0, spreadRadius: 0.0, offset: const Offset(0, 12)),
            BoxShadow(color: Colors.blue.withOpacity(0.03), blurRadius: 10.0, spreadRadius: 2.0, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28.0,
              backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
              backgroundImage: NetworkImage(user.avatarUrl),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.login,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                      color: Theme.of(context).textTheme.bodyLarge?.color, 
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  const Text("GitHub User", style: TextStyle(fontSize: 13.0, color: Colors.grey, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            if (isFavorite)
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(Icons.favorite, color: Colors.redAccent, size: 20.0),
              ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16.0, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}