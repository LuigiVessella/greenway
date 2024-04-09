import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:greenway/config/themes/first_theme.dart';
import 'package:greenway/presentation/pages/admin_page.dart';
import 'package:greenway/presentation/pages/delivery_man_page.dart';
import 'package:greenway/presentation/pages/login_page.dart';
import 'package:greenway/presentation/widgets/add_new_delivery_widget.dart';

Future<void> main() async {
  runApp(const MyApp());
  await dotenv.load(fileName: "lib/config/auth/auth_client.env");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: firstAppTheme,
      initialRoute: '/',
      routes: {
        
        //Definiamo a priori i nomi e tutti i possibili routing all'interno dell'app
        '/': (context) => const LoginPage(),
        // Il nome second è collegato ad admin page, third welcome page e cosi via.
        '/second': (context) => const AdminPage(),
        '/third': (context) => const DeliveryManPage(),
        '/deliveryS':(context) => const AddNewDelivery(title: 'Aggiungi mittente',),
        '/deliveryR':(context) => const AddNewDelivery(title: 'Aggiungi destinatario',),

      },
    );
  }
}
