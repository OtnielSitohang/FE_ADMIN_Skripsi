import 'package:flutter/material.dart';
import 'package:frontadmin/models/user.dart';
import 'package:frontadmin/pages/KonfirmasiLapanganPage.dart';
import 'package:frontadmin/pages/TambahAdminPage.dart';
import 'package:frontadmin/pages/TambahCustomerPage.dart';
import 'package:frontadmin/pages/TambahLapanganPage.dart';
import 'package:frontadmin/pages/dashboard_admin_pages.dart';
import 'package:frontadmin/pages/pengaturan_page.dart';
import 'package:frontadmin/pages/LaporanPage.dart';

class DrawerPage extends StatefulWidget {
  final User user;

  DrawerPage({required this.user});

  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Navigator.pop(context); // Close the drawer

    switch (index) {
      case 0:
        if (_selectedIndex != 0) {
          Navigator.pushReplacementNamed(context, '/dashboardAdmin');
        }
        break;
      case 1:
        if (_selectedIndex != 1) {
          Navigator.pushReplacementNamed(context, '/konfirmasiLapangan');
        }
        break;
      case 2:
        if (_selectedIndex != 2) {
          Navigator.pushReplacementNamed(context, '/tambahCustomer');
        }
        break;
      case 3:
        if (_selectedIndex != 3) {
          Navigator.pushReplacementNamed(context, '/tambahAdmin');
        }
        break;
      case 4:
        if (_selectedIndex != 4) {
          Navigator.pushReplacementNamed(context, '/tambahLapangan');
        }
        break;
      case 5:
        if (_selectedIndex != 5) {
          Navigator.pushReplacementNamed(context, '/laporan');
        }
        break;
      case 6:
        if (_selectedIndex != 6) {
          Navigator.pushReplacementNamed(context, '/pengaturan');
        }
        break;
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Logout'),
          content: Text('Apakah Anda yakin ingin logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(widget.user.nama_lengkap),
              accountEmail: Text(widget.user.email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: Icon(Icons.confirmation_number),
              title: Text('Konfirmasi Lapangan'),
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text('Tambah Customer'),
              onTap: () => _onItemTapped(2),
            ),
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text('Tambah Admin'),
              onTap: () => _onItemTapped(3),
            ),
            ListTile(
              leading: Icon(Icons.add_location),
              title: Text('Tambah Lapangan'),
              onTap: () => _onItemTapped(4),
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: Text('Laporan'),
              onTap: () => _onItemTapped(5),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Pengaturan'),
              onTap: () => _onItemTapped(6),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () => _showLogoutDialog(),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          DashboardAdminPage(), // Index 0
          KonfirmasiLapanganPage(), // Index 1
          TambahCustomerPage(), // Index 2
          TambahAdminPage(), // Index 3
          TambahLapanganPage(), // Index 4
          LaporanPage(), // Index 5
          PengaturanPage(), // Index 6
        ],
      ),
    );
  }
}
