import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String nama;
  final String nim;
  final String prodi;
  final String fakultas;
  final String kartuIdentitas;

  final String telepon;
  final String instagram;
  final String whatsapp;
  final String emailKontak;

  final String fotoProfil;

  final Timestamp createdAt;
  final Timestamp? updatedAt;
  final String verifikasiStatus;

  UserModel({
    required this.uid,
    required this.email,
    required this.nama,
    required this.nim,
    required this.prodi,
    required this.fakultas,
    required this.kartuIdentitas,
    required this.telepon,
    required this.instagram,
    required this.whatsapp,
    required this.emailKontak,
    required this.fotoProfil,
    required this.createdAt,
    this.updatedAt,
    required this.verifikasiStatus,
  });

  factory UserModel.empty(String uid, String email) {
    return UserModel(
      uid: uid,
      email: email,
      nama: "",
      nim: "",
      prodi: "",
      fakultas: "",
      kartuIdentitas: "",
      telepon: "",
      instagram: "",
      whatsapp: "",
      emailKontak: "",
      fotoProfil: "",
      createdAt: Timestamp.now(),
      updatedAt: null,
      verifikasiStatus: "none",
    );
  }

  UserModel copyWith({
    String? nama,
    String? nim,
    String? prodi,
    String? fakultas,
    String? kartuIdentitas,
    String? telepon,
    String? instagram,
    String? whatsapp,
    String? emailKontak,
    String? fotoProfil,
    Timestamp? updatedAt,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      nama: nama ?? this.nama,
      nim: nim ?? this.nim,
      prodi: prodi ?? this.prodi,
      fakultas: fakultas ?? this.fakultas,
      kartuIdentitas: kartuIdentitas ?? this.kartuIdentitas,
      telepon: telepon ?? this.telepon,
      instagram: instagram ?? this.instagram,
      whatsapp: whatsapp ?? this.whatsapp,
      emailKontak: emailKontak ?? this.emailKontak,
      fotoProfil: fotoProfil ?? this.fotoProfil,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      verifikasiStatus: this.verifikasiStatus,
    );
  }

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return UserModel(
      uid: doc.id,
      email: data["email"] ?? "",
      nama: data["nama"] ?? "",
      nim: data["nim"] ?? "",
      prodi: data["prodi"] ?? "",
      fakultas: data["fakultas"] ?? "",
      kartuIdentitas: data["kartu_identitas"] ?? "",
      telepon: data["telepon"] ?? "",
      instagram: data["instagram"] ?? "",
      whatsapp: data["whatsapp"] ?? "",
      emailKontak: data["email_kontak"] ?? "",
      fotoProfil: data["fotoProfil"] ?? "",
      createdAt: data["createdAt"] ?? Timestamp.now(),
      updatedAt: data["updatedAt"],
      verifikasiStatus: (data["verifikasi_identitas"]?["status"]) ?? "none",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "nama": nama,
      "nim": nim,
      "prodi": prodi,
      "fakultas": fakultas,
      "kartu_identitas": kartuIdentitas,
      "telepon": telepon,
      "instagram": instagram,
      "whatsapp": whatsapp,
      "email_kontak": emailKontak,
      "fotoProfil": fotoProfil,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }
}
