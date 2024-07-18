class Pengguna {
  final String username;
  final String password;
  final String namaLengkap;
  final String tanggalLahir;
  final String email;
  final String tempatTinggal;
  final String role;
  final String fotoBase64;

  Pengguna({
    required this.username,
    required this.password,
    required this.namaLengkap,
    required this.tanggalLahir,
    required this.email,
    required this.tempatTinggal,
    required this.role,
    required this.fotoBase64,
  });
}
