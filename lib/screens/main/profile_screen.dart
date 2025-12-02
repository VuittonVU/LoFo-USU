import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // --------------------------------------------------
  // Ambil user data dari Firestore
  // --------------------------------------------------
  Future<Map<String, dynamic>?> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final snap =
    await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    return snap.data();
  }

  // --------------------------------------------------
  // Jumlah laporan user
  // --------------------------------------------------
  Stream<int> _countUserReports(String userId) {
    return FirebaseFirestore.instance
        .collection('laporan')
        .where('id_pengguna', isEqualTo: userId)
        .snapshots()
        .map((snap) => snap.size);
  }

  // --------------------------------------------------
  // Jumlah laporan selesai
  // --------------------------------------------------
  Stream<int> _countReturned(String userId) {
    return FirebaseFirestore.instance
        .collection('laporan')
        .where('id_pengguna', isEqualTo: userId)
        .where('status_laporan', isEqualTo: "Selesai")
        .snapshots()
        .map((snap) => snap.size);
  }

  // --------------------------------------------------
  // Launcher Fix (versi baru url_launcher)
  // --------------------------------------------------
  Future<void> _launchUrl(String url) async {
    if (url.isEmpty || url == "-") return;
    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Gagal membuka $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFE3F3E3),

      // ============================================================
      // TOP BAR
      // ============================================================
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Container(
          height: 90,
          color: const Color(0xFF4CAF50),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SafeArea(
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Text(
                  "LoFo USU",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: PopupMenuButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onSelected: (value) {
                      if (value == "edit") {
                        context.push('/edit-profile');
                      } else if (value == "settings") {
                        context.push('/account-settings');
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: "edit", child: Text("Edit Profil")),
                      PopupMenuItem(
                          value: "settings", child: Text("Pengaturan Akun")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // ============================================================
      // BODY
      // ============================================================
      body: FutureBuilder(
        future: _getUserData(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;
          final foto = data["fotoProfil"] ?? "";
          final nama = data["nama"] ?? "-";
          final prodi = data["prodi"] ?? "-";
          final nim = data["nim"] ?? "-";

          final phone = data["telepon"] ?? "-";
          final ig = data["instagram"] ?? "-";
          final wa = data["whatsapp"] ?? "-";
          final email = user?.email ?? "-";

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // FOTO PROFIL
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green.shade300, width: 3),
                  ),
                  child: ClipOval(
                    child: foto.isEmpty
                        ? Image.asset("assets/images/pp.png", fit: BoxFit.cover)
                        : Image.network(
                      foto,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Image.asset("assets/images/pp.png"),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  nama,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(prodi,
                    style:
                    TextStyle(fontSize: 15, color: Colors.grey.shade700)),
                Text(nim,
                    style:
                    TextStyle(fontSize: 14, color: Colors.grey.shade700)),

                const SizedBox(height: 20),

                // =========================== STATISTIK ===========================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StreamBuilder<int>(
                      stream: _countUserReports(user!.uid),
                      builder: (_, snap) {
                        final c = snap.data ?? 0;
                        return _statCard("$c", "Laporan Dibuat");
                      },
                    ),
                    const SizedBox(width: 14),
                    StreamBuilder<int>(
                      stream: _countReturned(user.uid),
                      builder: (_, snap) {
                        final c = snap.data ?? 0;
                        return _statCard("$c", "Barang Dikembalikan");
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // =========================== KONTAK ===========================
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
                      const Text("Kontak:",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 14),

                      _contactItem(
                        icon: Image.asset("assets/icons/phone.png", height: 22),
                        label: "Nomor Telepon:",
                        value: phone,
                        onTap: () => _launchUrl("tel:$phone"),
                      ),

                      _contactItem(
                        icon:
                        Image.asset("assets/icons/instagram.png", height: 22),
                        label: "Instagram:",
                        value: ig,
                        onTap: () => _launchUrl("https://instagram.com/$ig"),
                      ),

                      _contactItem(
                        icon:
                        Image.asset("assets/icons/whatsapp.png", height: 22),
                        label: "Whatsapp:",
                        value: wa,
                        onTap: () => _launchUrl("https://wa.me/$wa"),
                      ),

                      _contactItem(
                        icon: Image.asset("assets/icons/mail.png", height: 22),
                        label: "Email:",
                        value: email,
                        onTap: () => _launchUrl("mailto:$email"),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // WIDGET STAT CARD
  // ============================================================
  Widget _statCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: Column(
        children: [
          Text(value,
              style:
              const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }

  // ============================================================
  // WIDGET KONTAK ITEM
  // ============================================================
  Widget _contactItem({
    required Widget icon,
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border:
          Border.all(color: Colors.green.withOpacity(0.4), width: 1.4),
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 10),
            Expanded(
              child: RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 15),
                  children: [
                    TextSpan(
                        text: "$label ",
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    TextSpan(
                        text: value,
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
