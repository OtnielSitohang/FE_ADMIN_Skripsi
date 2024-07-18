import 'dart:convert';
import 'package:http/http.dart' as http;

class PenggunaService {
  static Future<void> tambahPengguna({
    required String username,
    required String password,
    required String namaLengkap,
    required String tanggalLahir,
    required String email,
    required String tempatTinggal,
    required String role,
  }) async {
    final url = Uri.parse('http://localhost:3000/auth/register');

    final Map<String, dynamic> penggunaData = {
      'username': username,
      'password': password,
      'nama_lengkap': namaLengkap,
      'tanggal_lahir': tanggalLahir,
      'email': email,
      'tempat_tinggal': tempatTinggal,
      'role': role,
    };

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(penggunaData),
      );

      if (response.statusCode == 201) {
        // Jika berhasil menambahkan pengguna
        return;
      } else {
        // Jika gagal menambahkan pengguna
        throw Exception('Failed to add user');
      }
    } catch (e) {
      // Handle error
      throw Exception('Failed to add user: $e');
    }
  }
}
