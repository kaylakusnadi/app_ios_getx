import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/notification_controller.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final notifC = Get.find<NotificationController>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => notifC.markAsRead());
  }

  List<TextSpan> _buildRichText(String text) {
    final parts = text.split('|');
    List<TextSpan> spans = [];
    for (int i = 0; i < parts.length; i++) {
      if (i % 2 != 0) {
        spans.add(TextSpan(
          text: parts[i],
          style: TextStyle(fontWeight: FontWeight.w700, color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 14),
        ));
      } else {
        spans.add(TextSpan(
          text: parts[i],
          style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 14),
        ));
      }
    }
    return spans;
  }

// Fungsi untuk mengecek apakah dua waktu berada di hari yang sama
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

// Fungsi untuk menghasilkan teks header (Hari ini, Kemarin, atau Tanggal Lengkap)
  String _getDateHeader(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (dateToCheck == today) {
      return "Hari ini";
    } else if (dateToCheck == yesterday) {
      return "Kemarin";
    } else {
      return DateFormat('EEEE, dd MMMM yyyy').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Notifikasi", style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: Obx(() {
        if (notifC.items.isEmpty) {
          return const Center(child: Text("Belum ada riwayat notifikasi.", style: TextStyle(color: Colors.grey)));
        }
        return ListView.builder(
          padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
          itemCount: notifC.items.length,
          itemBuilder: (context, index) {
            final item = notifC.items[index];
            
            // Mengecek item sebelumnya untuk menentukan apakah perlu mencetak Header Tanggal
            final previousItem = index == 0 ? null : notifC.items[index - 1];
            final bool showHeader = previousItem == null || !_isSameDay(item.timestamp, previousItem.timestamp);
            
            final isDeleteAction = item.message.contains("Menghapus");
            
// Updated: 2026-07-03 by Kayla
// Change: Mengimplementasikan Date Grouping (Pengelompokan Tanggal) pada riwayat notifikasi
// Reason: Meningkatkan UX dengan memisahkan label hari/tanggal sebagai header di atas card, layaknya standar aplikasi modern, sehingga card hanya perlu menampilkan jam.
            final formattedTime = DateFormat('HH:mm').format(item.timestamp);
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Render Header Tanggal hanya jika harinya berbeda dengan notifikasi sebelumnya
                if (showHeader)
                  Padding(
                    padding: const EdgeInsets.only(left: 26.0, right: 26.0, top: 20.0, bottom: 8.0),
                    child: Text(
                      _getDateHeader(item.timestamp),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.grey,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                
                // Bubble Card Notifikasi
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16.0, offset: const Offset(0, 8)),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: isDeleteAction ? Colors.red.shade50 : Colors.blue.shade50,
                        radius: 24,
                        child: Icon(isDeleteAction ? Icons.favorite_border : Icons.favorite, color: isDeleteAction ? Colors.redAccent : Colors.blueAccent, size: 20),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(text: TextSpan(children: _buildRichText(item.message))),
                            const SizedBox(height: 6),
                            Text(formattedTime, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}