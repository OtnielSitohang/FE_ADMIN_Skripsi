import 'package:frontadmin/global/url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VoucherService {
  // Function to fetch all vouchers
  Future<List<dynamic>> fetchVouchers() async {
    final response = await http.get(Uri.parse('$baseUrlApi/getVoucher'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load vouchers');
    }
  }

  // Function to add a new voucher
  Future<void> addVoucher({
    required String kode,
    required int diskon,
    required int status,
    required DateTime tanggalMulai,
    required DateTime tanggalSelesai,
    required int batasPenggunaan,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrlApi/addVoucher'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'kode': kode,
        'diskon': diskon,
        'status': status,
        'tanggal_mulai': tanggalMulai.toIso8601String(),
        'tanggal_selesai': tanggalSelesai.toIso8601String(),
        'batas_penggunaan': batasPenggunaan,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add voucher');
    }
  }

  Future<void> updateVoucher({
    required int id,
    String? kode,
    int? diskon,
    int? status,
    String? tanggalSelesai,
    int? batasPenggunaan,
  }) async {
    final Map<String, dynamic> body = {};
    if (kode != null) body['kode'] = kode;
    if (diskon != null) body['diskon'] = diskon;
    if (status != null) body['status'] = status;
    if (tanggalSelesai != null) body['tanggal_selesai'] = tanggalSelesai;
    if (batasPenggunaan != null) body['batas_penggunaan'] = batasPenggunaan;

    print('Updating voucher with id: $id');
    print('Request body: $body');

    final response = await http.put(
      Uri.parse('$baseUrlApi/voucher/$id'), // Pastikan ID dikirim di URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to update voucher');
    }
  }

  
}
