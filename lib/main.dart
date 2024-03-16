import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:greenway/login_page.dart';


Future<void> main() async {
  runApp(MyApp());
  await dotenv.load(fileName: "lib/config/auth/auth_client.env");
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage()
    );
  }
}