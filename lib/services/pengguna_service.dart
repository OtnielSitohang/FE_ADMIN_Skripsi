import 'dart:convert';
import 'package:frontadmin/global/url.dart';
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
    final url = Uri.parse('$baseUrlauth/register');

    final Map<String, dynamic> penggunaData = {
      'username': username,
      'password': password,
      'nama_lengkap': namaLengkap,
      'tanggal_lahir': tanggalLahir,
      'email': email,
      'tempat_tinggal': tempatTinggal,
      'role': role,
    };

    print('Sending data: ${jsonEncode(penggunaData)}'); // Debugging statement

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(penggunaData),
      );

      print('Response status: ${response.statusCode}'); // Debugging statement
      print('Response body: ${response.body}'); // Debugging statement

      if (response.statusCode == 201) {
        // Jika berhasil menambahkan pengguna
        return;
      } else {
        // Jika gagal menambahkan pengguna
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        throw Exception(
          'Failed to add user: ${responseData['message'] ?? 'No error message provided'}',
        );
      }
    } catch (e) {
      // Handle error
      print('Error: $e'); // Debugging statement
      throw Exception('Failed to add user: $e');
    }
  }
}
