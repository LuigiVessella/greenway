import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greenway/repositories/deliveryman_repository.dart';
import 'package:greenway/services/network/logger.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isBusy = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Visibility(
              visible: _isBusy,
              child: const LinearProgressIndicator(),
            ),
            const SizedBox(
              height: 150,
            ),
            SvgPicture.asset('lib/assets/undraw_delivery_truck_vt6p.svg',
                height: 100),
            const SizedBox(height: 50),
            const Text("Benvenuto, esegui il login"),
            ElevatedButton(
                style: const ButtonStyle(
                    minimumSize: MaterialStatePropertyAll(Size(200, 40)),
                    maximumSize: MaterialStatePropertyAll(Size(300, 50))),
                onPressed: () async {
                  if (Platform.isIOS) {
                    AuthService().signInWithAutoCodeExchange(
                        preferEphemeralSession: true);
                  } else {
                    AuthService().signInWithAutoCodeExchange();
                  }
                  _checkBusy();
                  Future.delayed(
                    const Duration(seconds: 2),
                    () {
                      _checkBusy();
                    },
                  );
                },
                child: const Text('Login')),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                AuthService().endSession();
              },
              child: const Text('Logout'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
                onPressed: () {
                  final snackBar = SnackBar(
                      content: const Text('Please login first'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ));
                  if (AuthService().isLoggedIn &&
                      AuthService().getUserInfo!.contains('ADMIN')) {
                    Navigator.pushNamed(context, '/second');
                  } else if (AuthService().isLoggedIn &&
                      AuthService().getUserInfo!.contains('DELIVERY')) {
                        _checkDeliveyman();
                    Navigator.pushNamed(context, '/third');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: const Text('Procedi')),
          ],
        ),
      ),
    );
  }

  void _checkBusy() {
    if (AuthService().isBusy) {
      setState(() {
        _isBusy = true;
      });
    } else {
      setState(() {
        _isBusy = false;
      });
    }
  }

  void _checkDeliveyman(){
    DeliveryManRepository dmr = DeliveryManRepository();
    try{
      dmr.createDeliveryMan();
    }catch(e){
      print(e.toString());
    }

  }
}
