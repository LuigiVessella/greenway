import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:greenway/config/ip_config.dart';
import 'package:greenway/presentation/pages/web_pages/admin_web_dashboard.dart';
import 'package:greenway/services/network/logger.dart';
import 'package:greenway/services/network/logger_web.dart';
import 'package:openidconnect/openidconnect.dart';

//import 'credentials.dart';
//
//import 'identity_view.dart';

class InteractivePage extends StatefulWidget {
  const InteractivePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _InteractivePageState createState() => _InteractivePageState();
}

class _InteractivePageState extends State<InteractivePage> {
  @override
  void initState() {
    _loadIp();
    // TODO: implement initState
    super.initState();
  }

  bool usePopup = true;

  String? errorMessage;
  AuthorizationResponse? identity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Benvenuto, effettua il login!'),
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
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
            const SizedBox(
              height: 100,
            ),
            SvgPicture.asset('lib/assets/undraw_package_arrived_63rf.svg',
                height: 100),
            const SizedBox(
              height: 80,
            ),
            FilledButton.icon(
              onPressed: () async {
                try {
                  print(IpAddressManager().ipAddress);
                  if (mounted) {
                    await OIDCAuthService().authenticate(context: context);
                  }

                  setState(() {
                    identity = OIDCAuthService().identity;
                    AuthService().setAccessToken(identity!.accessToken);
                  });
                } on Exception catch (e) {
                  setState(() {
                    errorMessage = e.toString();
                    identity = null;
                  });
                }
              },
              icon: const Icon(Icons.login),
              label: const Text("Login"),
            ),
            const SizedBox(
              height: 15,
            ),
            Visibility(
              visible: identity != null,
              child: identity == null
                  ? Container()
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Loggato correttamente'),
                        Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                      ],
                    ),
            ),
            const SizedBox(
              height: 30,
            ),
            Visibility(
                visible: OIDCAuthService().isAuthenticated(),
                child: FilledButton(
                    onPressed: () {
                      if (OIDCAuthService().isAuthenticated()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const WebDashboard()));
                      }
                    },
                    child: const Text('Procedi'))),
            const SizedBox(
              height: 30,
            ),
            TextButton.icon(
              onPressed: () async {
                try {
                  await OIDCAuthService().logout();
                  if (mounted) {
                    setState(() {
                      identity = null;
                    });
                  }
                } on Exception catch (e) {
                  // Handle the logout exception (e.g., print error message)
                  print('Errore durante il logout: $e');
                  setState(() {
                    identity = null;
                    OIDCAuthService().identity = null;
                    errorMessage = null;
                  });
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
            ),
            const SizedBox(
              height: 30,
            ),
            Visibility(
              visible: errorMessage != null,
              child: const Column(
                children: [
                  Icon(size: 50, Icons.warning, color: Colors.yellow),
                  SelectableText(
                      textScaler: TextScaler.linear(1.5),
                      minLines: 3,
                      "Verifica il tuo ip o la connessione" ?? "")
                ],
              ),
            ),
          ])),
    );
  }

  void _loadIp() async {
    await IpAddressManager().loadAddress();
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
                  decoration: const InputDecoration(hintText: 'es. 192.168.1.7'),
                ),
                const SizedBox(height: 5,),
                const Divider(),
                const SizedBox(height: 5,),
                const Text(
                    'Ricarica la pagina per rendere effettive le modifiche.')
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('Annulla'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            TextButton(
              child: const Text('Modifica'),
              onPressed: () async {
                await IpAddressManager().setIpAddress(ipTextController.text);

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
