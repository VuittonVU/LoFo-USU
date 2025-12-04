import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ============================================================
  // GET USER DATA
  // ============================================================
  Future<Map<String, dynamic>> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};

    final snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    return snap.data() ?? {};
  }

  // ============================================================
  // COUNT USER REPORTS
  // ============================================================
  Stream<int> _countUserReports(String uid) {
    return FirebaseFirestore.instance
        .collection("laporan")
        .where("id_pengguna", isEqualTo: uid)
        .snapshots()
        .map((s) => s.size);
  }

  // ============================================================
  // COUNT FINISHED REPORTS
  // ============================================================
  Stream<int> _countReturned(String uid) {
    return FirebaseFirestore.instance
        .collection("laporan")
        .where("id_pengguna", isEqualTo: uid)
        .where("status_laporan", isEqualTo: "Selesai")
        .snapshots()
        .map((s) => s.size);
  }

  // ============================================================
  // SAFE URL LAUNCHER
  // ============================================================
  Future<void> _launch(String url) async {
    if (url.trim().isEmpty || url == "-") return;
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  // ============================================================
  // BUILD
  // ============================================================
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFE3F3E3),

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
                      fontWeight: FontWeight.w700),
                ),

                Positioned(
                  right: 0,
                  child: PopupMenuButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onSelected: (value) async {
                      if (value == "edit") {
                        await context.push("/edit-profile");

                        // 🔥 Setelah kembali dari edit-profile → REFRESH data
                        setState(() {});
                      }
                      else if (value == "settings") {
                        context.push("/account-settings");
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: "edit", child: Text("Edit Profil")),
                      PopupMenuItem(
                          value: "settings", child: Text("Pengaturan Akun")),
                    ],
                  ),
                )
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

          final data = snapshot.data as Map<String, dynamic>;

          final foto = (data["fotoProfil"] ?? "").toString();
          final nama = (data["nama"] ?? "-").toString();
          final prodi = (data["prodi"] ?? "-").toString();
          final nim = (data["nim"] ?? "-").toString();

          final phone = (data["telepon"] ?? "-").toString();
          final igRaw = (data["instagram"] ?? "-").toString();
          final wa = (data["whatsapp"] ?? "-").toString();
          final emailKontak = (data["email_kontak"] ?? "-").toString();

          final ig = igRaw.startsWith("@") ? igRaw.substring(1) : igRaw;

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
                        ? Image.asset("assets/images/pp.png",
                        fit: BoxFit.cover)
                        : Image.network(
                      foto,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Image.asset("assets/images/pp.png"),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Text(nama,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(prodi,
                    style:
                    TextStyle(fontSize: 15, color: Colors.grey.shade700)),
                Text(nim,
                    style:
                    TextStyle(fontSize: 14, color: Colors.grey.shade700)),

                const SizedBox(height: 20),

                // ============================================================
                // STATISTIK
                // ============================================================
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
                        return _statCard("$c", "Dikembalikan");
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ============================================================
                // KONTAK
                // ============================================================
                _buildContactSection(
                    phone, igRaw, ig, wa, emailKontak),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // CONTACT SECTION
  // ============================================================
  Widget _buildContactSection(
      String phone, String igRaw, String ig, String wa, String emailKontak) {
    return Container(
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),

          _contactItem(Icons.phone, "Nomor Telepon:", phone,
                  () => _launch("tel:$phone")),

          _contactItem(Icons.camera_alt, "Instagram:", igRaw,
                  () => _launch("https://instagram.com/$ig")),

          _contactItem(Icons.chat, "WhatsApp:", wa,
                  () => _launch("https://wa.me/$wa")),

          _contactItem(Icons.mail, "Email Kontak:", emailKontak,
                  () => _launch("mailto:$emailKontak")),
        ],
      ),
    );
  }

  // ============================================================
  // STAT CARD
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
  // CONTACT ITEM
  // ============================================================
  Widget _contactItem(
      IconData icon, String label, String value, VoidCallback onTap) {
    return InkWell(
      onTap: value == "-" ? null : onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.green.withOpacity(0.4)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.green),
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
