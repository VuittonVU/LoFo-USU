import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/routes.dart';
import '../../../widgets/profile_stats.dart';
import '../../../widgets/contact_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF43A047),
        title: const Text('LoFo USU'),
        centerTitle: true,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'edit') {
                context.go(AppRoutes.editProfile);
              } else if (value == 'settings') {
                context.go(AppRoutes.accountSettings);
              }
            },
            itemBuilder: (ctx) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit Profil')),
              PopupMenuItem(value: 'settings', child: Text('Pengaturan Akun')),
            ],
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            children: [
              CircleAvatar(
                radius: 56,
                backgroundImage: AssetImage('assets/images/avatar_profile.png'),
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(height: 12),
              const Text('Budi Siregar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('Ilmu Komunikasi', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 2),
              const Text('231401063', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 18),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  ProfileStats(count: 4, label: 'Laporan Dibuat'),
                  SizedBox(width: 12),
                  ProfileStats(count: 1, label: 'Barang Dikembalikan'),
                ],
              ),

              const SizedBox(height: 18),

              const ContactCard(
                phone: '0895-6229-2408',
                instagram: '@sayudins',
                whatsapp: '0895-6229-2408',
                email: 'udinSimanjuntak940@usu.ac.id',
              ),

              const SizedBox(height: 20),

              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Pengaturan Profil'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go(AppRoutes.accountSettings),
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go(AppRoutes.addLaporan),
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF43A047),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(onPressed: () => context.go(AppRoutes.mainNav + '?startIndex=0'), icon: const Icon(Icons.home)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
              const SizedBox(width: 48),
              IconButton(onPressed: () => context.go(AppRoutes.notif), icon: const Icon(Icons.notifications)),
              IconButton(onPressed: () => context.go(AppRoutes.profile), icon: const Icon(Icons.person)),
            ],
          ),
        ),
      ),
    );
  }
}