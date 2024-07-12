import 'package:flutter/material.dart';
import '../models/user.dart';

class DashboardPage extends StatelessWidget {
  final User user;

  DashboardPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Center(
        child: Text('Welcome, ${user.namaLengkap}'),
      ),
    );
  }
}
