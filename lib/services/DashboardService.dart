import 'dart:convert';
import 'package:frontadmin/global/url.dart';
import 'package:http/http.dart' as http;
import 'package:frontadmin/models/dashboard_model.dart';

class DashboardService {
  Future<List<NewUserData>> getNewUsersPerMonth() async {
    final response = await http.get(Uri.parse('$baseUrlApi/newuserspermonth'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => NewUserData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load new users per month');
    }
  }

  Future<List<BookingPerMonth>> getBookingsPerMonth() async {
    final response = await http.get(Uri.parse('$baseUrlApi/bookingspermonth'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => BookingPerMonth.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load bookings per month');
    }
  }

  Future<List<BookingPerJenisLapangan>> getBookingsPerJenisLapangan() async {
    final response =
        await http.get(Uri.parse('$baseUrlApi/bookingsperjenislapangan'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData
          .map((json) => BookingPerJenisLapangan.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load bookings per jenis lapangan');
    }
  }

  Future<List<RevenuePerMonth>> getRevenuePerMonth() async {
    final response = await http.get(Uri.parse('$baseUrlApi/revenuepermonth'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => RevenuePerMonth.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load revenue per month');
    }
  }

  Future<List<BookingByStatus>> getBookingsByStatus() async {
    final response = await http.get(Uri.parse('$baseUrlApi/bookingsbystatus'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => BookingByStatus.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load bookings by status');
    }
  }

  Future<List<BookingPerUser>> getBookingsPerUser() async {
    final response = await http.get(Uri.parse('$baseUrlApi/bookingsperuser'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => BookingPerUser.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load bookings per user');
    }
  }
}
