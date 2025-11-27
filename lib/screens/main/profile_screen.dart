import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F3E3),

        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: Container(
            height: 90,
            width: double.infinity,
            color: const Color(0xFF4CAF50),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SafeArea(
              bottom: false,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // ===========================
                  // FIXED CENTER TITLE
                  // ===========================
                  const Center(
                    child: Text(
                      "LoFo USU",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  // ===========================
                  // POPUP MENU (KANAN)
                  // ===========================
                  Positioned(
                    right: 0,
                    child: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      offset: const Offset(0, 50),
                      onSelected: (value) {
                        if (value == "edit") {
                          context.push('/edit-profile');
                        } else if (value == "settings") {
                          context.push('/account-settings');
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: "edit",
                          child: Text("Edit Profil"),
                        ),
                        PopupMenuItem(
                          value: "settings",
                          child: Text("Pengaturan Akun"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // =================================================================
            // FOTO PROFIL
            // =================================================================
            Column(
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green.shade300, width: 3),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      "assets/images/avatar.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                const Text(
                  "Budi Siregar",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Ilmu Komunikasi",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "231401063",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // =================================================================
            // STAT CARDS
            // =================================================================
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _statCard("4", "Laporan Dibuat"),
                const SizedBox(width: 14),
                _statCard("1", "Barang Dikembalikan"),
              ],
            ),

            const SizedBox(height: 24),

            // =================================================================
            // KONTAK BOX
            // =================================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.green.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Kontak:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ITEMS
                  _contactItem(
                    icon: Image.asset("assets/icons/phone.png", height: 22),
                    label: "Nomor Telepon:",
                    value: "0895-6229-2408",
                  ),
                  _contactItem(
                    icon: Image.asset("assets/icons/instagram.png", height: 22),
                    label: "Instagram:",
                    value: "@sayaUdins",
                  ),
                  _contactItem(
                    icon: Image.asset("assets/icons/whatsapp.png", height: 22),
                    label: "Whatsapp:",
                    value: "0895-6229-2408",
                  ),
                  _contactItem(
                    icon: Image.asset("assets/icons/mail.png", height: 22),
                    label: "email:",
                    value: "udinSianjutak940@usu.ac.id",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // =================================================================
  // STAT CARD
  // =================================================================
  Widget _statCard(String count, String label) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4CAF50),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // =================================================================
  // CONTACT ITEM — FIXED VERSION
  // =================================================================
  Widget _contactItem({
    required Widget icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.green.withOpacity(0.4),
          width: 1.4,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 10),

          // LABEL + VALUE (ELLIPSIS FIX)
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 15),
                children: [
                  TextSpan(
                    text: "$label ",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
