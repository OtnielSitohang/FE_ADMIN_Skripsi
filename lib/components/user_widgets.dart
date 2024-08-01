import 'package:flutter/material.dart';

class UserCountCard extends StatelessWidget {
  final String title;
  final int count;

  UserCountCard({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
          vertical: 10, horizontal: 15), // Jarak antar card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserListCard extends StatelessWidget {
  final List<Map<String, dynamic>> users;
  final void Function(int) onResetPassword;

  UserListCard({required this.users, required this.onResetPassword});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.blueGrey[50],
            child: Text(
              'Daftar Pengguna',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: users.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: Colors.grey[300]),
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                leading: CircleAvatar(
                  backgroundColor:
                      user['role'] == 'admin' ? Colors.red : Colors.green,
                  child: Icon(
                    user['role'] == 'admin'
                        ? Icons.admin_panel_settings
                        : Icons.person,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  user['nama_lengkap'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Username: ${user['username']}',
                        style: TextStyle(fontSize: 14)),
                    Text('Email: ${user['email']}',
                        style: TextStyle(fontSize: 14)),
                    Text('Tempat Tinggal: ${user['tempat_tinggal']}',
                        style: TextStyle(fontSize: 14)),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () => onResetPassword(user['id']),
                  child: Text('Reset Password'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red, // Text color
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
