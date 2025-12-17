import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';

class ReportUserScreen extends StatefulWidget {
  final String reportedUid;
  const ReportUserScreen({super.key, required this.reportedUid});

  @override
  State<ReportUserScreen> createState() => _ReportUserScreenState();
}

class _ReportUserScreenState extends State<ReportUserScreen> {
  String reason = "Penipuan";
  final noteCtrl = TextEditingController();
  bool loading = false;

  final reasons = [
    "Penipuan",
    "Identitas palsu",
    "Konten tidak pantas",
    "Pelecehan",
    "Lainnya",
  ];

  Future<void> _submit() async {
    setState(() => loading = true);

    await FirestoreService.instance.reportUser(
      reportedUid: widget.reportedUid,
      reason: reason,
      note: noteCtrl.text.trim(),
    );

    if (!mounted) return;
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Laporan berhasil dikirim")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporkan Akun"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField(
              value: reason,
              items: reasons
                  .map((e) =>
                  DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => reason = v!),
              decoration: const InputDecoration(
                labelText: "Alasan",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: noteCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Keterangan tambahan (opsional)",
                border: OutlineInputBorder(),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Kirim Laporan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
