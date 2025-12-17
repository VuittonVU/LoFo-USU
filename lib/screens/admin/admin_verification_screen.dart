import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';

class AdminVerificationsScreen extends StatelessWidget {
  const AdminVerificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verifikasi Identitas"),
        backgroundColor: const Color(0xFF2F9E44),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: FirestoreService.instance.streamPendingVerifications(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snap.hasData || snap.data!.isEmpty) {
            return const Center(
              child: Text("Tidak ada verifikasi pending"),
            );
          }

          final users = snap.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final u = users[i];

              return InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => _UserVerificationDetail(data: u),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        u["nama"] ?? "-",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text("NIM: ${u["nim"] ?? "-"}"),
                      Text("Prodi: ${u["prodi"] ?? "-"}"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _UserVerificationDetail extends StatelessWidget {
  final Map<String, dynamic> data;

  const _UserVerificationDetail({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = data["kartu_identitas"];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Identitas"),
        backgroundColor: const Color(0xFF2F9E44),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nama: ${data["nama"] ?? "-"}"),
            Text("NIM: ${data["nim"] ?? "-"}"),
            Text("Prodi: ${data["prodi"] ?? "-"}"),
            Text("Fakultas: ${data["fakultas"] ?? "-"}"),
            const SizedBox(height: 16),

            const Text(
              "Kartu Identitas",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: imageUrl == null || imageUrl == ""
                  ? const Center(child: Text("Tidak ada foto"))
                  : Image.network(imageUrl, fit: BoxFit.contain),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () async {
                      await FirestoreService.instance.rejectUser(data["uid"]);
                      Navigator.pop(context);
                    },
                    child: const Text("Tolak"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () async {
                      await FirestoreService.instance.approveUser(data["uid"]);
                      Navigator.pop(context);
                    },
                    child: const Text("Setujui"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}