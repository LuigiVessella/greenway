import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:greenway/config/ip_config.dart';
import 'package:greenway/config/themes/first_theme.dart';
import 'package:greenway/presentation/pages/admin_page.dart';
import 'package:greenway/presentation/pages/delivery_man_page.dart';
import 'package:greenway/presentation/pages/login_page.dart';
import 'package:greenway/presentation/pages/web_pages/login_web_page.dart';
import 'package:greenway/presentation/pages/map_page.dart';
import 'package:greenway/presentation/widgets/add_new_delivery_package.dart';

Future<void> main() async {
  //await IpAddressManager().firstAddress();
  await dotenv.load(fileName: "lib/config/auth/auth_client.env");
  await IpAddressManager().loadAddress();

  kIsWeb ? runApp(const MyWebApp()) : runApp(const MyApp());
}

class MyWebApp extends StatelessWidget {
  const MyWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'GreenWay',
      debugShowCheckedModeBanner: false,
      theme: firstAppTheme,
      home: const InteractivePage(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenWay',
      debugShowCheckedModeBanner: false,
      theme: firstAppTheme,
      initialRoute: '/', // Logica di selezione della route
      routes: {
        //Definiamo a priori i nomi e tutti i possibili routing all'interno dell'app
        '/': (context) => const LoginPage(),
        '/loginWeb': (context) => const InteractivePage(),
        // Il nome second è collegato ad admin page, third welcome page e cosi via.
        '/adminPage': (context) => const AdminPage(),
        '/deliveryManPage': (context) => const DeliveryManPage(),
        '/deliveryS': (context) => const AddNewPackage(
              title: 'Aggiungi mittente',
            ),
        '/deliveryR': (context) => const AddNewPackage(
              title: 'Aggiungi destinatario',
            ),
        'mapPage': (context) => const NavigationWidget(vehicleID: 0,)
      },
    );
  }
}
