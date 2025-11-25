class Validators {
  static String? usuEmail(String value) {
    if (value.isEmpty) return "Email tidak boleh kosong";

    // Mengizinkan SEMUA email yang berakhiran .usu.ac.id
    final pattern = RegExp(r".+@(.+\.)?usu\.ac\.id$");

    if (!pattern.hasMatch(value)) {
      return "Gunakan email resmi USU";
    }

    return null;
  }

  static String? password(String value) {
    if (value.isEmpty) return "Password tidak boleh kosong";
    if (value.length < 6) return "Password minimal 6 karakter";
    return null;
  }

  static String? confirmPassword(String pass, String confirm) {
    if (confirm.isEmpty) return "Konfirmasi password wajib diisi";
    if (confirm != pass) return "Password tidak sama";
    return null;
  }
}
