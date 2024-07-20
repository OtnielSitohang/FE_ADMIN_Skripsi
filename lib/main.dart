import 'package:flutter/material.dart';
import 'package:frontadmin/models/UserProvider.dart';
import 'package:frontadmin/services/auth_service.dart';
import 'package:frontadmin/services/ubahpassword_service.dart';
import 'package:provider/provider.dart';
import 'package:frontadmin/services/theme_provider.dart';
import 'package:frontadmin/app_router.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<UbahPasswordService>(create: (_) => UbahPasswordService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Admin Login',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: themeProvider.themeMode == ThemeMode.dark
                ? Brightness.dark
                : Brightness.light,
          ),
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: '/',
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
