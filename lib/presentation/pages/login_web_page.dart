import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:greenway/presentation/widgets/identity_view.dart';
import 'package:openidconnect/openidconnect.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//import 'credentials.dart';
//
//import 'identity_view.dart';

class InteractivePage extends StatefulWidget {
  const InteractivePage({super.key});

  @override
  _InteractivePageState createState() => _InteractivePageState();
}

class _InteractivePageState extends State<InteractivePage> {
  final defaultscopes = [
    "openid",
    "profile",
    "email",
  ];

  final defaultRedirectUrl = "http://localhost:61401/callback.html";
  final _formKey = GlobalKey<FormState>();

  String clientId = dotenv.env['clientID']!;
  String discoveryUrl = dotenv.env['discoveryUrl']!;
  String clientSecret = dotenv.env['CLIENT_SECRET']!;
  OpenIdConfiguration? discoveryDocument;
  AuthorizationResponse? identity;
  bool usePopup = true;

  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OpenIdConnect Code Flow with PKCE Example'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: "Discovery Url"),
                keyboardType: TextInputType.url,
                initialValue: discoveryUrl,
                onChanged: (value) => discoveryUrl = value,
                validator: (value) {
                  const errorMessage =
                      "Please enter a valid openid discovery document url";
                  if (value == null || value.isEmpty) return errorMessage;
                  try {
                    Uri.parse(value);
                    return null;
                  } on Exception catch (e) {
                    print(e.toString());
                    return errorMessage;
                  }
                },
              ),
              TextButton.icon(
                onPressed: () async {
                  _formKey.currentState!.save();
                  if (!_formKey.currentState!.validate()) return;

                  try {
                    final configuration =
                        await OpenIdConnect.getConfiguration(discoveryUrl);
                    setState(() {
                      discoveryDocument = configuration;
                      errorMessage = null;
                    });
                  } on Exception catch (e) {
                    setState(() {
                      errorMessage = e.toString();
                      discoveryDocument = null;
                    });
                  }
                },
                icon: const Icon(Icons.search),
                label: const Text("Lookup OpenId Connect Configuration"),
              ),
              Visibility(
                visible: kIsWeb,
                child: SwitchListTile.adaptive(
                  value: usePopup,
                  title: const Text("Use Web Popup"),
                  onChanged: (value) {
                    setState(() {
                      usePopup = value;
                    });
                  },
                ),
              ),
              Visibility(
                visible: discoveryDocument != null,
                child: TextButton.icon(
                  onPressed: () async {
                    try {
                      final response = await OpenIdConnect.authorizeInteractive(
                        context: context,
                        title: "Login",
                        request: await InteractiveAuthorizationRequest.create(
                          clientId: clientId,
                          clientSecret: clientSecret,
                          redirectUrl: defaultRedirectUrl,
                          scopes: defaultscopes,
                          configuration: discoveryDocument!,
                          autoRefresh: false,
                          useWebPopup: usePopup,
                        ),
                      );
                      setState(() {
                        identity = response;
                        errorMessage = null;
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
                visible: identity != null,
                child: TextButton.icon(
                  onPressed: () async {
                    OpenIdConnect.logout(
                      request: LogoutRequest(
                        idToken: identity!.idToken,
                        configuration: discoveryDocument!,
                      ),
                    );
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
