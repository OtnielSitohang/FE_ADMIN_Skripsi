import 'package:flutter/material.dart';
import 'package:frontadmin/services/theme_provider.dart';
import 'package:provider/provider.dart';

class PengaturanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: Text('Tema Gelap'),
            value:
                Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark,
            onChanged: (bool value) {
              Provider.of<ThemeProvider>(context, listen: false)
                  .toggleTheme(value);
            },
          ),

          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Pengaturan Akun'),
            onTap: () {
              Navigator.pushNamed(
                  context, '/pengaturanAkun'); // Navigasi ke PengaturanAkunPage
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Ubah Password'),
            onTap: () {
              // Tambahkan navigasi ke halaman ubah password di sini
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifikasi'),
            onTap: () {
              // Tambahkan navigasi ke halaman notifikasi di sini
            },
          ),
          // Tambahkan pengaturan lainnya di sini
        ],
      ),
    );
  }
}
