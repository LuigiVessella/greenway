import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String _text = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: (text) {
            setState(() {
              _text = text;
            });
          },
        ),
        ElevatedButton(
          onPressed: () {
            // Fai qualcosa con il testo
            print(_text);
          },
          child: Text("Invia"),
        ),
      ],
    );
  }
}
