import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  bool notif = false;
  final _auth = AuthService();

  // ============================================================
  // POPUP KONFIRMASI (YA / TIDAK)
  // ============================================================
  void _confirmDialog({
    required String message,
    required VoidCallback onYes,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _choiceButton("Ya", Colors.red, onYes),
                const SizedBox(width: 16),
                _choiceButton("Tidak", Colors.green, () => Navigator.pop(context)),
              ],
            )
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BUTTON PILIHAN
  // ============================================================
  Widget _choiceButton(String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }

  // ============================================================
  // INPUT PASSWORD UNTUK DELETE ACCOUNT
  // ============================================================
  void _showPasswordDialogForDelete() {
    final passCtrl = TextEditingController();
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Konfirmasi Password"),
        content: TextField(
          controller: passCtrl,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: "Masukkan password akun Anda",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              final msg = await _auth.deleteAccount(
                email: user.email!,
                password: passCtrl.text.trim(),
              );

              if (!mounted) return;

              if (msg != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(msg), backgroundColor: Colors.red),
                );
                return;
              }

              context.go('/signin');
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // UI
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F3E3),

      appBar: AppBar(
        title: const Text(
          "LoFo USU",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4CAF50),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // NOTIFIKASI
          _settingTile(
            title: "Notifikasi / Pemberitahuan",
            icon: notif ? Icons.notifications_active : Icons.notifications_off,
            color: Colors.green,
            onTap: () => setState(() => notif = !notif),
          ),

          // LOGOUT
          _settingTile(
            title: "Keluar dari Akun",
            icon: Icons.logout,
            color: Colors.green,
            onTap: () {
              _confirmDialog(
                message: "Apakah Anda yakin keluar dari akun?",
                onYes: () async {
                  Navigator.pop(context);
                  await _auth.signOut();
                  context.go('/signin');
                },
              );
            },
          ),

          // DELETE ACCOUNT
          _settingTile(
            title: "Hapus Akun",
            icon: Icons.delete,
            color: Colors.red,
            onTap: () {
              _confirmDialog(
                message: "Apakah Anda yakin menghapus akun?",
                onYes: () async {
                  Navigator.pop(context);
                  _showPasswordDialogForDelete();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TEMPLATE TILE SETTING
  // ============================================================
  Widget _settingTile({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(14),
        ),
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
