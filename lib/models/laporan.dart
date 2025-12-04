import 'package:cloud_firestore/cloud_firestore.dart';

class Laporan {
  final String id;
  final String idPengguna;
  final String? idPengklaim;
  final String namaBarang;
  final String namaPelapor;
  final String kategori;
  final String lokasi;
  final String deskripsi;
  final String tanggal;
  final List<String> fotoBarang;
  final String statusLaporan;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  Laporan({
    required this.id,
    required this.idPengguna,
    required this.idPengklaim,
    required this.namaBarang,
    required this.namaPelapor,
    required this.kategori,
    required this.lokasi,
    required this.deskripsi,
    required this.tanggal,
    required this.fotoBarang,
    required this.statusLaporan,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Laporan.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Laporan(
      id: doc.id,
      idPengguna: data["id_pengguna"],
      idPengklaim: data["id_pengklaim"],
      namaBarang: data["nama_barang"],
      namaPelapor: data["nama_pelapor"],
      kategori: data["kategori"],
      lokasi: data["lokasi"],
      deskripsi: data["deskripsi"],
      tanggal: data["tanggal"],
      fotoBarang: List<String>.from(data["foto_barang"] ?? []),
      statusLaporan: data["status_laporan"],
      createdAt: data["createdAt"],
      updatedAt: data["updatedAt"],
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
      "status_laporan": statusLaporan,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }
}
