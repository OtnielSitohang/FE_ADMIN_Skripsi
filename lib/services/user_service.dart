import 'dart:convert';
import 'package:http/http.dart' as http;
import '../global/url.dart'; // Pastikan URL ini berisi baseUrl global

class UserService {
  Future<Map<String, dynamic>> fetchUserData() async {
    final response = await http.get(Uri.parse('$baseUrlApi/users'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return {
        'counts': data['counts'] as Map<String, dynamic>,
        'users': (data['users'] as List<dynamic>)
            .map((item) => item as Map<String, dynamic>)
            .toList(),
      };
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<void> resetPassword(int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrlApi/resetpassword/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to reset password');
    }
  }
}
