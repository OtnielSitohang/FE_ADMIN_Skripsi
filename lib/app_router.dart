import 'package:flutter/material.dart';
import 'package:frontadmin/models/user.dart';
import 'package:frontadmin/pages/LaporanPage.dart';
import 'package:frontadmin/pages/TambahAdminPage.dart';
import 'package:frontadmin/pages/TambahLapanganPage.dart';
import 'package:frontadmin/pages/dashboard_admin_pages.dart';
import 'package:frontadmin/pages/drawer_page.dart';
import 'package:frontadmin/pages/login_page.dart';
import 'package:frontadmin/pages/pengaturan_page.dart';
import 'package:frontadmin/pages/KonfirmasiLapanganPage.dart';
import 'package:frontadmin/pages/TambahCustomerPage.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/drawer':
        final user = settings.arguments as User;
        return MaterialPageRoute(builder: (_) => DrawerPage(user: user));
      case '/dashboardAdmin':
        return MaterialPageRoute(builder: (_) => DashboardAdminPage());
      case '/konfirmasiLapangan':
        return MaterialPageRoute(builder: (_) => KonfirmasiLapanganPage());
      case '/tambahCustomer':
        return MaterialPageRoute(builder: (_) => TambahCustomerPage());
      case '/tambahAdmin':
        return MaterialPageRoute(builder: (_) => TambahAdminPage());
      case '/tambahLapangan':
        return MaterialPageRoute(builder: (_) => TambahLapanganPage());
      case '/laporan':
        return MaterialPageRoute(builder: (_) => LaporanPage());
      case '/pengaturan':
        return MaterialPageRoute(builder: (_) => PengaturanPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
