
import 'package:greenway/config/ip_config.dart';
import 'package:greenway/services/network/logger.dart';
import 'package:http/http.dart' as http;

class HttpDeliveryManResponse {
  final client = http.Client();

  Future<void> createDeliveryMan() async {
    
    var response = await client.post(
        Uri.http('${IpAddressManager().ipAddress}:8080', '/api/v1/deliveryMen'),
        headers: {
          'Authorization': 'Bearer ${AuthService().accessToken}',
          'Content-Type': 'application/json'
        },
        body: null);

    print('Creazione deliveryman: ${response.statusCode}');
  }


}