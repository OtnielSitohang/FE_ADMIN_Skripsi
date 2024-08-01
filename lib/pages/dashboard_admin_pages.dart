import 'package:flutter/material.dart';
import 'package:frontadmin/components/user_widgets.dart';
import 'package:frontadmin/services/user_service.dart';

class DashboardAdminPage extends StatefulWidget {
  @override
  _DashboardAdminPageState createState() => _DashboardAdminPageState();
}

class _DashboardAdminPageState extends State<DashboardAdminPage> {
  late Future<Map<String, dynamic>> userData;
  final UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    userData = userService.fetchUserData();
  }

  void _resetPassword(int userId) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset Password'),
        content: Text('Apakah Anda yakin ingin mereset password pengguna ini?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(true);
              try {
                await userService.resetPassword(userId);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Password telah direset.')),
                );
                setState(() {
                  userData = userService.fetchUserData(); // Refresh data
                });
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal mereset password: $error')),
                );
              }
            },
            child: Text('Ya'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await userService.resetPassword(userId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password telah direset.')),
        );
        setState(() {
          userData = userService.fetchUserData(); // Refresh data
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mereset password: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Admin'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data available'));
          } else {
            final data = snapshot.data!;
            final int adminCount = data['counts']['admin'] ?? 0;
            final int customerCount = data['counts']['customer'] ?? 0;
            final List<Map<String, dynamic>> users =
                List<Map<String, dynamic>>.from(data['users'] ?? []);

            final List<Map<String, dynamic>> adminUsers =
                users.where((user) => user['role'] == 'admin').toList();
            final List<Map<String, dynamic>> customerUsers =
                users.where((user) => user['role'] == 'customer').toList();

            return ListView(
              padding: EdgeInsets.symmetric(vertical: 10),
              children: <Widget>[
                UserCountCard(title: 'Jumlah Customer', count: customerCount),
                SizedBox(height: 20), // Jarak antar card
                UserListCard(
                    users: customerUsers, onResetPassword: _resetPassword),
                SizedBox(height: 20), // Jarak antar card
                UserCountCard(title: 'Jumlah Admin', count: adminCount),
                SizedBox(height: 20), // Jarak antar card
                UserListCard(
                    users: adminUsers, onResetPassword: _resetPassword),
              ],
            );
          }
        },
      ),
    );
  }
}
