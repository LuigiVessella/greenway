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
    _ipAddress = prefs?.getString('ip') ?? "192.168.1.7";
  }

  String get ipAddress => _ipAddress;

  // Metodo setter per impostare l'indirizzo IP
  void setIpAddress(String newIpAddress) async {
    prefs = await SharedPreferences.getInstance();
    _ipAddress = newIpAddress;
    print('new address $_ipAddress');
    await prefs!.setString('ip', _ipAddress);
  }
}
