import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/routes.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController(text: 'Budi Siregar');
  final fakultasCtrl = TextEditingController(text: 'Ilmu Komunikasi');
  final nimCtrl = TextEditingController(text: '231401063');
  final phoneCtrl = TextEditingController(text: '0895-6229-2408');

  @override
  void dispose() {
    nameCtrl.dispose();
    fakultasCtrl.dispose();
    nimCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Berhasil'),
          content: const Text('Profil berhasil diperbarui.'),
          actions: [
            TextButton(onPressed: () {
              context.pop();
              context.go(AppRoutes.profile);
            }, child: const Text('OK')),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        backgroundColor: const Color(0xFF43A047),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    const CircleAvatar(radius: 52, backgroundImage: AssetImage('assets/images/avatar_profile.png')),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: const Icon(Icons.edit, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (v) => (v == null || v.isEmpty) ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: fakultasCtrl,
                decoration: const InputDecoration(labelText: 'Fakultas / Jurusan'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: nimCtrl,
                decoration: const InputDecoration(labelText: 'NIM'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'Nomor Telepon'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}