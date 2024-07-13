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

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'namaLengkap': namaLengkap,
      'fotoBase64': fotoBase64,
      'tanggalLahir': tanggalLahir,
      'email': email,
      'tempatTinggal': tempatTinggal,
      'role': role,
    };
  }

  User copyWith({
    String? username,
    String? namaLengkap,
    String? fotoBase64,
    String? tanggalLahir,
    String? email,
    String? tempatTinggal,
    String? role,
  }) {
    return User(
      username: username ?? this.username,
      namaLengkap: namaLengkap ?? this.namaLengkap,
      fotoBase64: fotoBase64 ?? this.fotoBase64,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      email: email ?? this.email,
      tempatTinggal: tempatTinggal ?? this.tempatTinggal,
      role: role ?? this.role,
    );
  }
}
