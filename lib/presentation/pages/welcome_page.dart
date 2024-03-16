import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:greenway/config/themes/first_theme.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
   
     return MaterialApp(
      theme: firstAppTheme,
      home: Scaffold(
     
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 30),
              Image.asset('lib/assets/welcome_page_image.png', height: 200, width: 200,),
              SizedBox(height: 10),
              Text(
                'Welcome to your homepage!',
                style: TextStyle(
                  fontSize: 24
                ),
              ),
              SizedBox(height: 50),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Inserisci il modello del veicolo',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: Text('Invia'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

