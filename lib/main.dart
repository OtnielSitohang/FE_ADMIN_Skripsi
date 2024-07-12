import 'package:flutter/material.dart';
import 'package:frontadmin/models/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:frontadmin/app_router.dart';
import 'package:frontadmin/services/theme_provider.dart'; // Pastikan file theme_provider.dart sesuai dengan penamaan yang benar

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
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
