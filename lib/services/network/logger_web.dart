import 'package:flutter/material.dart';
import 'package:openidconnect/openidconnect.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OIDCAuthService {
  // Istanza Singleton
  static final OIDCAuthService _instance = OIDCAuthService._internal();
  factory OIDCAuthService() => _instance;
  OIDCAuthService._internal();

  // Variabili
  String clientId = dotenv.env['clientID']!;
  String discoveryUrl = dotenv.env['discoveryUrl']!;
  String clientSecret = dotenv.env['CLIENT_SECRET']!;

  bool _isLogged = false;

  OpenIdConfiguration? discoveryDocument;
  AuthorizationResponse? identity;

  // Metodo per acquisire la configurazione OpenID Connect
  Future<OpenIdConfiguration> _fetchConfiguration() async {
    try {
      final configuration = await OpenIdConnect.getConfiguration(discoveryUrl);
      discoveryDocument = configuration;
      return configuration;
    } on Exception catch (e) {
      throw Exception(
          'Errore durante il recupero della configurazione OpenID Connect: $e');
    }
  }

  // Metodo per l'autenticazione
  Future<AuthorizationResponse?> authenticate(
      {bool usePopup = true, required BuildContext context}) async {
    if (discoveryDocument == null) {
      await _fetchConfiguration(); // Recupera la configurazione se necessario
    }

    try {
      final response = await OpenIdConnect.authorizeInteractive(
        context:
            context, // L'esempio richiedeva il 'context', ma qui non sarà necessario
        title: "Login",
        request: await InteractiveAuthorizationRequest.create(
          clientId: clientId,
          clientSecret: clientSecret,
          redirectUrl: "http://localhost:64510/callback.html", // Redirect URL
          scopes: ["openid", "profile", "email"],
          configuration: discoveryDocument!,
          autoRefresh: true,
          useWebPopup: usePopup,
        ),
      );

      identity = response;

      _isLogged = true;
      
      return response;
    } on Exception catch (e) {
      throw Exception('Errore durante l\'autenticazione OpenID Connect: $e');
    }
  }

  Future<AuthorizationResponse?> refresh() async {
    if (discoveryDocument == null) {
      await _fetchConfiguration(); // Recupera la configurazione se necessario
    }

    RefreshRequest request = RefreshRequest(
        clientId: clientId,
        scopes: ["openid", "profile", "email"],
        refreshToken: identity!.refreshToken!,
        configuration: discoveryDocument!);

    try {
      final response = await OpenIdConnect.refreshToken(request: request);

      identity = response;

      _isLogged = true;
      return response;
    } on Exception catch (e) {
      throw Exception('Errore durante l\'autenticazione OpenID Connect: $e');
    }
  }

  // Metodo per il logout
  Future<void> logout() async {
    if (identity == null || discoveryDocument == null) {
      return; // Nulla da fare se l'utente non è loggato
    }

    try {
      await OpenIdConnect.logout(
        request: LogoutRequest(
          idToken: identity!.idToken,
          configuration: discoveryDocument!,
        ),
      );
      _isLogged = false;
      identity = null;
    } on Exception catch (e) {
      throw Exception('Errore durante il logout OpenID Connect: $e');
    }
  }

  // Metodo per verificare se l'utente è loggato
  bool isAuthenticated() => _isLogged;

  // Metodo per ottenere i token d'accesso e d'identità
  String? get accessToken {
    DateTime now = DateTime.now();

    if (now.isBefore(identity!.expiresAt)) {
      return identity!.accessToken;
    } else {
      OIDCAuthService._instance.refresh();
      return identity!.accessToken;
    }
  }

  String? get idToken => identity!.idToken;
}
