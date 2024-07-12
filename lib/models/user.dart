class User {
  final String username;
  final String namaLengkap;
  final String fotoBase64;
  final String tanggalLahir;
  final String email;
  final String tempatTinggal;
  final String role;

  User({
    required this.username,
    required this.namaLengkap,
    required this.fotoBase64,
    required this.tanggalLahir,
    required this.email,
    required this.tempatTinggal,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      namaLengkap: json['namaLengkap'],
      fotoBase64: json['fotoBase64'],
      tanggalLahir: json['tanggalLahir'],
      email: json['email'],
      tempatTinggal: json['tempatTinggal'],
      role: json['role'],
    );
  }
}
