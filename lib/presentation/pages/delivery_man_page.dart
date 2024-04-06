import 'package:flutter/material.dart';

class DeliveryManPage extends StatelessWidget {
  const DeliveryManPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 30),
            Image.asset(
              'lib/assets/welcome_page_image.png',
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 10),
            const Text(
              'Benvenuto!\nDa qui puoi vedere le tue consegne',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 50),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Inserisci il modello del veicolo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Invia'),
            ),
          ],
        ),
      ),
    );
  }



  
}
