import 'dart:convert';
import 'package:http/http.dart' as http;

class LapanganService {
  static const String baseUrl = 'http://localhost:3000/auth/lapangan';

  static Future<String> createLapangan(
      int jenisLapanganId, String namaLapangan, int harga) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: jsonEncode({
          'jenis_lapangan_id': jenisLapanganId,
          'nama_lapangan': namaLapangan,
          'harga': harga.toString(),
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body)['message'];
      } else {
        return 'Failed to create lapangan. Status code: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error creating lapangan: $e';
    }
  }
}
