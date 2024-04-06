// ignore_for_file: unused_field

import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ... altre importazioni, configurazione come dotenv

class AuthService {
  static final AuthService _instance = AuthService._privateConstructor();
  factory AuthService() => _instance;

  //con factory stiamo praticamente dicendo che non possono esistere più istanze di questa classe. se esistono, sono uguali.
  final FlutterAppAuth _appAuth = const FlutterAppAuth();

  //variabili private
  bool _isBusy = false;
  String? _codeVerifier;
  String? _nonce;
  String? _authorizationCode;
  String? _refreshToken;
  String? _accessToken;
  String? _idToken;
  String? _expDate;
  String? _userInfo;
  Map<String, dynamic>? _decodedToken;

  bool _isLoggingComplete = false;

  //setting per il server keycloak che fornisce oauth2
  final String _clientId = 'GreenWay';
  final String _redirectUrl = 'com.example.greenway:/';
  final String _issuer = 'http://192.168.1.9:8090/realms/GreenWay';
  //final String _discoveryUrl =
  //    'http://192.168.1.9:8090/realms/GreenWay/.well-known/openid-configuration';
  final String _postLogoutRedirectUrl = 'com.example.greenway:/';
  final List<String> _scopes = <String>['openid', 'profile', 'email'];

  final AuthorizationServiceConfiguration _serviceConfiguration =
      const AuthorizationServiceConfiguration(
    authorizationEndpoint:
        'http://192.168.1.9:8090/realms/GreenWay/protocol/openid-connect/auth',
    tokenEndpoint:
        'http://192.168.1.9:8090/realms/GreenWay/protocol/openid-connect/token',
    endSessionEndpoint:
        'http://192.168.1.9:8090/realms/GreenWay/protocol/openid-connect/logout',
  );

  AuthService._privateConstructor();

  Future<void> signInWithAutoCodeExchange(
      {bool preferEphemeralSession = false}) async {
    try {
      _setBusyState();

      final AuthorizationTokenResponse? result =
          await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(_clientId, _redirectUrl,
            clientSecret: dotenv.env[
                'CLIENT_SECRET'], //file .env di configurazione in config/auth
            serviceConfiguration: _serviceConfiguration,
            scopes: _scopes,
            preferEphemeralSession: preferEphemeralSession,
            allowInsecureConnections: true),
      );

      if (result != null) {
        _processAuthTokenResponse(result);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', result.accessToken.toString());
      }
    } catch (_) {
      _clearBusyState();
    }
  }

  Future<void> refresh() async {
    try {
      _setBusyState();
      final TokenResponse? result = await _appAuth.token(TokenRequest(
          _clientId, _redirectUrl,
          refreshToken: _refreshToken,
          issuer: _issuer,
          scopes: _scopes,
          clientSecret: dotenv.env['CLIENT_SECRET'],
          allowInsecureConnections: true));
      _processTokenResponse(result);
    } catch (_) {
      _clearBusyState();
    }
  }

  void _processAuthTokenResponse(AuthorizationTokenResponse response) {
    _accessToken = response.accessToken!;
    _idToken = response.idToken!;
    _refreshToken = response.refreshToken!;
    _expDate = response.accessTokenExpirationDateTime!.toIso8601String();
    _isLoggingComplete = true;
    _isBusy = false;
    _decodedToken = JwtDecoder.decode(_accessToken.toString());
   _expDate = JwtDecoder.getExpirationDate(_accessToken.toString()).toString();
    print(_expDate);
    print(_decodedToken);
   _userInfo = _decodedToken?["realm_access"].toString();
   print(_userInfo);
  }

  void _processTokenResponse(TokenResponse? response) {
    _accessToken = response!.accessToken!;
    _idToken = response.idToken!;
    _refreshToken = response.refreshToken!;
    _expDate = response.accessTokenExpirationDateTime!.toIso8601String();
    _isBusy = false;
  }

  Future<void> endSession() async {
    try {
      _setBusyState();
      await _appAuth.endSession(EndSessionRequest(
          idTokenHint: _idToken,
          postLogoutRedirectUrl: _postLogoutRedirectUrl,
          serviceConfiguration: _serviceConfiguration));
      _clearSessionInfo();
    } catch (_) {}
    _clearBusyState();
  }

  void _clearSessionInfo() {
    _codeVerifier = null;
    _nonce = null;
    _authorizationCode = null;
    _accessToken = null;
    _idToken = null;
    _refreshToken = null;
    _userInfo = null;
    _expDate = null;
  }

  void _clearBusyState() {
    _isBusy = false;
  }

  void _setBusyState() {
    _isBusy = true;
  }

  bool get isLoggedIn => _accessToken != null; // Helper per la UI
  bool get isBusy => _isBusy != false;
  bool get isLoginComplete => _isLoggingComplete != false;
  String? get getUserInfo => _userInfo;

  String? get accessToken {
      DateTime now = DateTime.now();
      DateTime expDate = DateTime.parse(_expDate!); 
      
      if (now.isBefore(expDate)) {
        return _accessToken;
      } else {
         refresh();
         return _accessToken;
      }
  } 
  
  String? get refreshToken => _refreshToken;
}
