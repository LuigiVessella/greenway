import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IpAddressManager {
  // Proprietà privata per l'indirizzo IP
  String _ipAddress = "";
  SharedPreferences? prefs;

  // Costruttore privato per impedire l'instanziazione diretta
  IpAddressManager._privateConstructor();

  // Istanza singleton statica
  static final IpAddressManager _instance =
      IpAddressManager._privateConstructor();

  // Factory getter per ottenere l'istanza singleton
  factory IpAddressManager() {
    return _instance;
  }

  // Metodo getter per ottenere l'indirizzo IP
  Future<void> loadAddress() async {
    prefs = await SharedPreferences.getInstance();
    if (kIsWeb) {
      print('sono quii kiswe');
      if (prefs?.getString('ip') != null || prefs!.getString('ip') != '') {
        _ipAddress = prefs!.getString('ip') ?? dotenv.get('web_address');
        print('ho preso $_ipAddress');
      }
    } else {
      _ipAddress = prefs?.getString('ip') ?? "192.168.1.7";
    }
  }

  String get ipAddress => _ipAddress;

  // Metodo setter per impostare l'indirizzo IP
  Future<void> setIpAddress(String newIpAddress) async {
    prefs = await SharedPreferences.getInstance();
    _ipAddress = newIpAddress;
    print('new address $_ipAddress');
    await prefs!.setString('ip', _ipAddress);
  }
}
