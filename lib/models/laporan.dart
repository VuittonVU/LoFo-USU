import 'package:cloud_firestore/cloud_firestore.dart';

class Laporan {
  final String id;
  final String idPengguna;
  final String idPengklaim;
  final String namaBarang;
  final String namaPelapor;
  final String kategori;
  final String lokasi;
  final String deskripsi;
  final String tanggal;
  final String? namaPengklaim;

  final List<String> fotoBarang;
  final List<String> dokumentasi;
  final String statusLaporan;

  final Timestamp createdAt;
  final Timestamp updatedAt;

  Laporan({
    required this.id,
    required this.idPengguna,
    required this.namaBarang,
    required this.namaPelapor,
    required this.kategori,
    required this.lokasi,
    required this.deskripsi,
    required this.tanggal,
    required this.fotoBarang,
    required this.dokumentasi,
    required this.statusLaporan,
    required this.createdAt,
    required this.updatedAt,
    required this.namaPengklaim,
    required this.idPengklaim,
  });

  factory Laporan.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final rawDok = data['dokumentasi'];

    final List<String> dokumentasi = rawDok is List
        ? rawDok.whereType<String>().toList()
        : [];

    return Laporan(
      id: doc.id,
      idPengguna: data["id_pengguna"],
      namaBarang: data["nama_barang"],
      namaPelapor: data["nama_pelapor"],
      kategori: data["kategori"],
      lokasi: data["lokasi"],
      deskripsi: data["deskripsi"],
      tanggal: data["tanggal"],
      namaPengklaim: data["nama_pengklaim"],
      idPengklaim: data["id_pengklaim"],

      fotoBarang: List<String>.from(data["foto_barang"] ?? []),
      dokumentasi: dokumentasi,

      statusLaporan: data["status_laporan"],
      createdAt: data["createdAt"] ?? Timestamp.now(),
      updatedAt: data["updatedAt"] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id_pengguna": idPengguna,
      "id_pengklaim": idPengklaim,
      "nama_barang": namaBarang,
      "nama_pelapor": namaPelapor,
      "kategori": kategori,
      "lokasi": lokasi,
      "deskripsi": deskripsi,
      "tanggal": tanggal,
      "foto_barang": fotoBarang,
      "dokumentasi": dokumentasi,
      "status_laporan": statusLaporan,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }
}