import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isBusy = false;
  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  String? _codeVerifier;
  String? _nonce;
  String? _authorizationCode;
  String? _refreshToken;
  String? _accessToken;
  String? _idToken;

  bool _isLoggingComplete = false;

  final TextEditingController _authorizationCodeTextController =
      TextEditingController();
  final TextEditingController _accessTokenTextController =
      TextEditingController();
  final TextEditingController _accessTokenExpirationTextController =
      TextEditingController();

  final TextEditingController _idTokenTextController = TextEditingController();
  final TextEditingController _refreshTokenTextController =
      TextEditingController();
  String? _userInfo;

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('GreenWay Login'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: _isBusy,
                  child: const LinearProgressIndicator(),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  child: const Text('Sign in with auto code exchange'),
                  onPressed: () {
                    _signInWithAutoCodeExchange();
                  } 
                ),
                if (Platform.isIOS || Platform.isMacOS)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      child: const Text(
                        'Sign in with auto code exchange using ephemeral '
                        'session',
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        _signInWithAutoCodeExchange(
                            preferEphemeralSession: true);
                      },
                    ),
                  ),
                ElevatedButton(
                  child: const Text('Refresh token'),
                  onPressed: _refreshToken != null ? _refresh : null,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  child: const Text('End session'),
                  onPressed: _idToken != null
                      ? () async {
                          await _endSession();
                        }
                      : null,
                ),
                const SizedBox(height: 8),
                const Text('authorization code'),
                TextField(
                  controller: _authorizationCodeTextController,
                ),
                const Text('access token'),
                TextField(
                  controller: _accessTokenTextController,
                ),
                const Text('access token expiration'),
                TextField(
                  controller: _accessTokenExpirationTextController,
                ),
                const Text('id token'),
                TextField(
                  controller: _idTokenTextController,
                ),
                const Text('refresh token'),
                TextField(
                  controller: _refreshTokenTextController,
                ),
                const Text('test api results'),
                Text(_userInfo ?? ''),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _endSession() async {
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
    setState(() {
      _codeVerifier = null;
      _nonce = null;
      _authorizationCode = null;
      _authorizationCodeTextController.clear();
      _accessToken = null;
      _accessTokenTextController.clear();
      _idToken = null;
      _idTokenTextController.clear();
      _refreshToken = null;
      _refreshTokenTextController.clear();
      _accessTokenExpirationTextController.clear();
      _userInfo = null;
    });
  }

  Future<void> _refresh() async {
    try {
      _setBusyState();
      final TokenResponse? result = await _appAuth.token(TokenRequest(
          _clientId, _redirectUrl,
          refreshToken: _refreshToken,
          issuer: _issuer,
          scopes: _scopes,
          clientSecret: "jyTj9K8qcn3AoZjElhNCT15klfdiBH0K",
          allowInsecureConnections: true));
      _processTokenResponse(result);
     
    } catch (_) {
      _clearBusyState();
    }
  }



  Future<void> _signInWithAutoCodeExchange(
      {bool preferEphemeralSession = false}) async {
    try {
      _setBusyState();

      final AuthorizationTokenResponse? result =
          await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(_clientId, _redirectUrl,
            clientSecret:
                "jyTj9K8qcn3AoZjElhNCT15klfdiBH0K", //vedere come usare i segreti in flutter
            serviceConfiguration: _serviceConfiguration,
            scopes: _scopes,
            preferEphemeralSession: preferEphemeralSession,
            allowInsecureConnections: true),
      );

      if (result != null) {
        _processAuthTokenResponse(result);
        checkState();
    
      }
    } catch (_) {
      _clearBusyState();
    }
  }

  void _clearBusyState() {
    setState(() {
      _isBusy = false;
    });
  }

  void _setBusyState() {
    setState(() {
      _isBusy = true;
    });
  }

  void _processAuthTokenResponse(AuthorizationTokenResponse response) {
    setState(() {
      _accessToken = _accessTokenTextController.text = response.accessToken!;
      _idToken = _idTokenTextController.text = response.idToken!;
      _refreshToken = _refreshTokenTextController.text = response.refreshToken!;
      _accessTokenExpirationTextController.text =
          response.accessTokenExpirationDateTime!.toIso8601String();
      _isLoggingComplete = true;
    });
    checkState();
  }

  void _processAuthResponse(AuthorizationResponse response) {
    setState(() {
      /*
        Save the code verifier and nonce as it must be used when exchanging the
        token.
      */
      _codeVerifier = response.codeVerifier;
      _nonce = response.nonce;
      _authorizationCode =
          _authorizationCodeTextController.text = response.authorizationCode!;
      _isBusy = false;
    });
  }

  void _processTokenResponse(TokenResponse? response) {
    setState(() {
      _accessToken = _accessTokenTextController.text = response!.accessToken!;
      _idToken = _idTokenTextController.text = response.idToken!;
      _refreshToken = _refreshTokenTextController.text = response.refreshToken!;
      _accessTokenExpirationTextController.text =
          response.accessTokenExpirationDateTime!.toIso8601String();
    });
  }


  void checkState(){
    if(_isLoggingComplete) 
    {
      print ("sei entrato");
      
      
    }

  }
}
