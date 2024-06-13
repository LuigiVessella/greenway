import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greenway/components/components.dart';
import 'package:greenway/config/ip_config.dart';
import 'package:greenway/repositories/deliveryman_repository.dart';
import 'package:greenway/services/network/logging/logger.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

@override
class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    _loadIp();

    super.initState();
  }

  bool _isBusy = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Accedi'),
        centerTitle: true,
        actions: [
          IconButton.outlined(
              onPressed: () async {
                await IpAddressManager().loadAddress();
                await _settingsDialog();
              },
              icon: const Icon(Icons.settings))
        ],
      ),
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
                                    setState(() {});
                                    if (Platform.isIOS) {
                                      AuthService().signInWithAutoCodeExchange(
                                          preferEphemeralSession: true);
                                    } else {
                                      setState(() {
                                        _isBusy = true;
                                      });

                                      await AuthService()
                                          .signInWithAutoCodeExchange()
                                          .then(
                                        (value) {
                                          setState(() {
                                            _isBusy = false;
                                          });
                                        },
                                      ).whenComplete(
                                        () {
                                          setState(() {
                                            _isBusy = false;
                                          });
                                        },
                                      );
                                    }
                                  },
                                  child: const SizedBox(
                                    width: 200,
                                    child: Text('Accedi',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                  )),
                              OutlinedButton(
                                onPressed: () async {
                                  AuthService().endSession();
                                },
                                child: const SizedBox(
                                  width: 200,
                                  child: Text('Esci',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    const snackBar = SnackBar(
                                      backgroundColor: Colors.orange,
                                      content: Text(
                                        'Esegui il login!',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    );
                                    if (AuthService().isLoggedIn &&
                                        AuthService()
                                            .getUserRole!
                                            .contains('ADMIN')) {
                                      Navigator.pushNamed(
                                          context, '/adminPage');
                                    } else if (AuthService().isLoggedIn &&
                                        AuthService()
                                            .getUserRole!
                                            .contains('DELIVERY')) {
                                      _checkDeliveyman();
                                      Navigator.pushNamed(
                                          context, '/deliveryManPage');
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  },
                                  child: const Text('Procedi')),
                            ])))
              ]),
        ),
      ),
    );
  }

  void _checkDeliveyman() {
    DeliveryManRepository dmr = DeliveryManRepository();
    try {
      dmr.createDeliveryMan();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _settingsDialog() async {
    final ipTextController = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cambia indirizzo IP:'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  keyboardType: TextInputType.number,
                  controller: ipTextController,
                  decoration:
                      const InputDecoration(hintText: 'es. 192.168.1.7'),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                    'Ricarica la pagina per rendere effettive le modifiche.')
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Modifica'),
              onPressed: () {
                setState(() {
                  IpAddressManager().setIpAddress(ipTextController.text);
                });

                //Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _loadIp() async {
    await IpAddressManager().loadAddress();
  }
}
