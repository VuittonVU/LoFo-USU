import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  final String phone;
  final String instagram;
  final String whatsapp;
  final String email;

  const ContactCard({
    Key? key,
    required this.phone,
    required this.instagram,
    required this.whatsapp,
    required this.email,
  }) : super(key: key);

  Widget _row(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(radius: 16, backgroundColor: Colors.green[50], child: Icon(icon, size: 18, color: Colors.green)),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0,3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Kontak:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _row(Icons.phone, 'Nomor Telepon: $phone'),
          _row(Icons.camera_alt, 'Instagram: $instagram'),
          _row(Icons.message, 'WhatsApp: $whatsapp'),
          _row(Icons.email, 'Email: $email'),
        ],
      ),
    );
  }
}