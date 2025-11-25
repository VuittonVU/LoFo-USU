import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/routes.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({Key? key}) : super(key: key);

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(onPressed: () {
            // TODO: lakukan logout (hapus token/shared prefs)
            Navigator.pop(context);
            context.go(AppRoutes.signIn);
          }, child: const Text('Ya')),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Akun'),
        content: const Text('Apakah Anda yakin menghapus akun? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(onPressed: () {
            // TODO: panggil API hapus akun
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Akun berhasil dihapus')));
            context.go(AppRoutes.splash);
          }, child: const Text('Hapus', style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Akun'),
        backgroundColor: const Color(0xFF43A047),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Udin Simanjuntak'),
              subtitle: const Text('akun@usu.ac.id'),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifikasi / Pemberitahuan'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Keluar dari Akun'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _confirmLogout(context),
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => _confirmDelete(context),
            icon: const Icon(Icons.delete, color: Colors.red),
            label: const Text('Hapus Akun', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}