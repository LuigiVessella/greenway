import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:greenway/config/themes/first_theme.dart';
import 'package:greenway/presentation/pages/login_page.dart';

Future<void> main() async {
  runApp(MyApp());
  await dotenv.load(fileName: "lib/config/auth/auth_client.env");
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: firstAppTheme,
      home: const LoginPage(),
    );
  }
}
