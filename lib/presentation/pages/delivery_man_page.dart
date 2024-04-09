import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            SvgPicture.asset(
              'lib/assets/undraw_messenger_re_8bky.svg',
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
