import 'package:frontadmin/models/Booking.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Booking>> fetchBookings() async {
  final response =
      await http.get(Uri.parse('http://localhost:3000/auth/booking'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((booking) => Booking.fromJson(booking)).toList();
  } else {
    throw Exception('Failed to load bookings');
  }
}
