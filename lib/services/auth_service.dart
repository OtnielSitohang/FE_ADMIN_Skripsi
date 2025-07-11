import 'dart:convert';
import 'package:frontadmin/models/user.dart';
import 'package:frontadmin/utils/DateUtils.dart';
import 'package:http/http.dart' as http;
import '../global/url.dart';

class AuthService {
  Future<User?> login(String username, String password) async {
    try {
      final url = Uri.parse('$baseUrlauth/login');
      final response = await http.post(
        url,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null) {
          return User.fromJson(data['data']);
        } else {
          throw Exception('Invalid response: Data not complete');
        }
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during login: $e');
      throw Exception('Failed to login: $e');
    }
  }

  Future<Map<String, dynamic>?> updateProfile(User updatedUser) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrlauth/pengguna/${updatedUser.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'foto_base64': updatedUser.foto_base64,
          'email': updatedUser.email,
          'tempat_tinggal': updatedUser.tempat_tinggal,
          'tanggal_lahir': DateUtils.formatDateTime(updatedUser.tanggal_lahir),
        }),
      );

      print('Update Profile Response status: ${response.statusCode}');
      print('Update Profile Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['data'] != null) {
          return responseData['data'];
        } else {
          throw Exception('Failed to update profile: Data not complete');
        }
      } else {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating profile: $e');
      throw Exception('Failed to update profile: $e');
    }
  }
}
