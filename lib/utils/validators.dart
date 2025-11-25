class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return "Email tidak boleh kosong";
    }
    if (!value.contains("@") || !value.contains(".")) {
      return "Email tidak valid";
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return "Password wajib diisi";
    }
    if (value.length < 6) {
      return "Password minimal 6 karakter";
    }
    return null;
  }

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Field ini wajib diisi";
    }
    return null;
  }

  static String? usuEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email tidak boleh kosong";
    }

    final regex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@(students\.)?usu\.ac\.id$'
    );

    if (!regex.hasMatch(value.trim())) {
      return "Gunakan email USU (@usu.ac.id)";
    }

    return null;
  }
}
