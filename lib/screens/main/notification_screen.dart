import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/top_bar_backbtn.dart';

class NotificationScreen extends StatelessWidget {
  final Map<String, dynamic>? notificationData;

  const NotificationScreen({super.key, this.notificationData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFD7F0D6),
              Color(0xFFB5E0B4),
            ],
          ),
        ),
        child: Column(
          children: [
            // =========================================================
            // TOP BAR (MENGGUNAKAN WIDGET)
            // =========================================================
            TopBarBackBtn(
              title: "LoFo USU",
              onBack: () => context.go('/main'),
            ),

            // =========================================================
            // CONTENT
            // =========================================================
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                children: [
                  _buildDateBubble("03/10/2025"),
                  const SizedBox(height: 15),

                  // Build notification card with data passed
                  if (notificationData != null)
                    _buildNotificationCard(
                      notificationData?['title'] ?? 'No Title',
                      notificationData?['time'] ?? '00:00',
                    ),
                  const SizedBox(height: 35),
                  _buildDateBubble("01/10/2025"),
                  const SizedBox(height: 15),

                  _buildNotificationCard(
                    "Terima kasih sudah mengembalikan Kartu Identitas Mahasiswa milik Andi Budiman.",
                    "10:01",
                  ),

                  const SizedBox(height: 25),

                  _buildNotificationCard(
                    "Andi Budiman mengaku sebagai pemilik Kartu Identitas Mahasiswa dan akan segera menghubungi Anda.",
                    "08:30",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // DATE BUBBLE
  // =========================================================
  Widget _buildDateBubble(String date) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.green.shade300, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          date,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // =========================================================
  // NOTIFICATION CARD
  // =========================================================
  Widget _buildNotificationCard(String text, String time) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.13),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 28),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            right: 0,
            child: Text(
              time,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 13,
              ),
            ),
          )
        ],
      ),
    );
  }
}
