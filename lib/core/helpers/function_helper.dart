// Helper untuk validasi Email
String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) return 'Email tidak boleh kosong';
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) return 'Masukkan format email yang valid';
  return null;
}

// Helper untuk validasi Password
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) return 'Password tidak boleh kosong';
  if (value.length < 6) return 'Password minimal harus 6 karakter';
  return null;
}
