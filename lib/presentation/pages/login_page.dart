import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greenway/components/components.dart';
import 'package:greenway/presentation/pages/login_web_page.dart';
import 'package:greenway/repositories/deliveryman_repository.dart';
import 'package:greenway/services/network/logger.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

@override
class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  bool _isBusy = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Visibility(
              visible: _isBusy,
              child: const LinearProgressIndicator(),
            ),
            const SizedBox(
              height: 60,
            ),
            SvgPicture.asset('lib/assets/undraw_package_arrived_63rf.svg',
                height: 100),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(
                        right: 15.0, left: 15, bottom: 15),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const ScreenTitle(title: 'Ciao'),
                          const Text(
                              'Benvenuto in GreenWay, il navigatore Green',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                              )),
                          const Divider(),
                          const SizedBox(
                            height: 15,
                          ),
                          FilledButton(
                              onPressed: () async {
                                if (kIsWeb) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const InteractivePage()));
                                } else if (Platform.isIOS) {
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
                              child: const SizedBox(
                                width: 200,
                                child: Text('Login',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                              )),
                          ElevatedButton(
                            onPressed: () async {
                              AuthService().endSession();
                            },
                            child: const SizedBox(
                              width: 200,
                              child: Text('Logout',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
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
                                    AuthService()
                                        .getUserRole!
                                        .contains('ADMIN')) {
                                  Navigator.pushNamed(context, '/second');
                                } else if (AuthService().isLoggedIn &&
                                    AuthService()
                                        .getUserRole!
                                        .contains('DELIVERY')) {
                                  _checkDeliveyman();
                                  Navigator.pushNamed(context, '/third');
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              },
                              child: const Text('Procedi')),
                        ])))
          ],
        ),
      ),
    ));
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

  void _checkDeliveyman() {
    DeliveryManRepository dmr = DeliveryManRepository();
    try {
      dmr.createDeliveryMan();
    } catch (e) {
      print(e.toString());
    }
  }
}
