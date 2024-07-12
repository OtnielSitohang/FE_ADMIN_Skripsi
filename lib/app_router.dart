import 'package:flutter/material.dart';
import 'package:frontadmin/models/user.dart';
import 'pages/login_page.dart';
import 'pages/dashboard_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/dashboard':
        final user = settings.arguments as User;
        return MaterialPageRoute(builder: (_) => DashboardPage(user: user));
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
