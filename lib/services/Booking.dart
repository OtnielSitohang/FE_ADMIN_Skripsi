// BookingService.dart

import 'dart:convert';
import 'package:frontadmin/models/Booking.dart';
import 'package:frontadmin/models/lapangan.dart';
import 'package:http/http.dart' as http;
import '../global/url.dart';

class BookingService {
  // final String bookFieldUrl = '$baseUrlApi/booking/book';
  final String checkAvailabilityUrl = '$baseUrlApi/lapangan/available';
  final String fetchBookingsUrl = '$baseUrlApi/booking';
  final String fetchCustomersUrl =
      '$baseUrlApi/getCustomer'; // URL untuk mengambil pengguna

  // Method untuk memesan lapangan
  static Future<void> bookField({
    required int pengguna_id,
    required int lapangan_id,
    required int jenis_lapangan_id,
    required String tanggal_booking,
    required String tanggal_penggunaan,
    required String sesi,
  required double harga,
    required String foto_base64,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrlApi/booking/book'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'pengguna_id': pengguna_id,
        'lapangan_id': lapangan_id,
        'jenis_lapangan_id': jenis_lapangan_id,
        'tanggal_booking': tanggal_booking,
        'tanggal_penggunaan': tanggal_penggunaan,
        'sesi': sesi,
        'harga': harga,
        'foto_base64': foto_base64,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create booking');
    }
  }

  Future<List<Map<String, dynamic>>> checkAvailability({
    required String jenisLapanganId,
    required String tanggalPenggunaan,
    required String sesi,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(checkAvailabilityUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'jenis_lapangan_id': jenisLapanganId,
          'tanggal_penggunaan': tanggalPenggunaan,
          'sesi': sesi,
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((data) => data as Map<String, dynamic>)
            .toList();
      } else {
        throw Exception('Failed to check availability');
      }
    } catch (e) {
      print('Error checking availability: $e');
      rethrow;
    }
  }

  // Method untuk mengambil daftar booking
  Future<List<Booking>> fetchBookings() async {
    final response = await http.get(Uri.parse(fetchBookingsUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((booking) => Booking.fromJson(booking)).toList();
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  // Method untuk mengambil daftar pengguna
  Future<List<Map<String, String>>> fetchCustomers() async {
    try {
      final response = await http.get(Uri.parse(fetchCustomersUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> users = jsonResponse['users'];
        return users.map((user) {
          return {
            'id': user['id'].toString(),
            'username': user['username'].toString(),
          };
        }).toList();
      } else {
        throw Exception('Failed to fetch customers');
      }
    } catch (e) {
      print('Error fetching customers: $e');
      rethrow;
    }
  }
}
