import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:greenway/config/themes/first_theme.dart';
import 'package:greenway/presentation/pages/admin_page.dart';
import 'package:greenway/presentation/pages/delivery_man_page.dart';
import 'package:greenway/services/network/logger.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isBusy = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: firstAppTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('GreenWay App'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Visibility(
                visible: _isBusy,
                child: const LinearProgressIndicator(),
              ),
              const SizedBox(
                height: 8,
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
                    if (AuthService().isLoggedIn &&
                        AuthService().getUserInfo!.contains('ADMIN')) {
                      Navigator.pushNamed(context, '/second');
                    } else if (AuthService().isLoggedIn &&
                        AuthService().getUserInfo!.contains('DELIVERY')) {
                      Navigator.pushNamed(context, '/third');
                    } else {
                      Fluttertoast.showToast(
                          msg: "Please login first",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.green,
                          fontSize: 16.0);
                    }
                  },
                  child: const Text('Procedi')),
            ],
          ),
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
}
