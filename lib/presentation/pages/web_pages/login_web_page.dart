import 'package:flutter/material.dart';
import 'package:greenway/presentation/pages/web_pages/admin_web_dashboard.dart';
import 'package:greenway/presentation/widgets/identity_view.dart';
import 'package:greenway/services/network/logger.dart';
import 'package:greenway/services/network/logger_web.dart';
import 'package:openidconnect/openidconnect.dart';

//import 'credentials.dart';
//
//import 'identity_view.dart';

class InteractivePage extends StatefulWidget {
  const InteractivePage({super.key});

  @override
  _InteractivePageState createState() => _InteractivePageState();
}

class _InteractivePageState extends State<InteractivePage> {
  final _formKey = GlobalKey<FormState>();

  bool usePopup = true;

  String? errorMessage;
  AuthorizationResponse? identity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Benvenuto, effettua il login!'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextButton.icon(
                onPressed: () async {
                  try {
                    if (mounted) {
                      final response = await OIDCAuthService()
                          .authenticate(context: context);
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
              Visibility(
                visible: identity != null,
                child: identity == null ? Container() : IdentityView(identity!),
              ),
              Visibility(
                visible: errorMessage != null,
                child: SelectableText(errorMessage ?? ""),
              ),
              Visibility(
                  visible: OIDCAuthService().isAuthenticated(),
                  child: FilledButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const WebDashboard()));
                      },
                      child: const Text('Procedi'))),
              Visibility(
                visible: identity != null,
                child: TextButton.icon(
                  onPressed: () async {
                    OIDCAuthService().logout();
                    setState(() {
                      identity = null;
                    });
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
