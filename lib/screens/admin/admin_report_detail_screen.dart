import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';

class AdminReportDetailScreen extends StatelessWidget {
  final Map<String, dynamic> report;

  const AdminReportDetailScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Laporan Akun"),
        backgroundColor: const Color(0xFF2F9E44),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _item("UID Dilaporkan", report["reported_uid"]),
            _item("UID Pelapor", report["reporter_uid"]),
            _item("Status", report["status"]),
            const SizedBox(height: 12),
            const Text(
              "Alasan Laporan:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(report["reason"] ?? "-"),

            const Spacer(),

            if (report["status"] == "pending")
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () async {
                        await FirestoreService.instance
                            .updateAccountReportStatus(
                          reportId: report["id"],
                          status: "rejected",
                        );
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
                        await FirestoreService.instance
                            .updateAccountReportStatus(
                          reportId: report["id"],
                          status: "reviewed",
                        );
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

  Widget _item(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              )),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
