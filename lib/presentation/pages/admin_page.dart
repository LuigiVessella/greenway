import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:greenway/config/themes/first_theme.dart';
import 'package:greenway/presentation/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: firstAppTheme,
      home: Scaffold(
          body: Center(
        child: Column(children: <Widget>[
          const SizedBox(
            height: 30,
          ),
          Image.asset(
            'lib/assets/welcome_page_image.png',
            height: 200,
            width: 200,
          ),
          const Text('Benvenuto admin'),
          const Text('Come stai'),
          const SizedBox(
            height: 40,
          ),
           FilledButton(
            onPressed: () {},
            style: const ButtonStyle(minimumSize: MaterialStatePropertyAll(Size(200,50))), 
            child: const Text('Add vehicle'),),
            const SizedBox(height: 20,),
            FilledButton(onPressed: (){readToken();}, child: const Text('Add delivery'))
        ]),
      )),
    );
  }

  Future readToken() async{
    print('ciao');
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token').toString();
    print('token: $token');
  }
}
