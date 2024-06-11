
import 'package:greenway/config/ip_config.dart';
import 'package:greenway/services/network/logger.dart';
import 'package:http/http.dart' as http;

class HttpSystemResponse{
  final client = http.Client();

  Future<void> triggerDeliveryScheduling() async{
    var response = await client.get(
        Uri.http('${IpAddressManager().ipAddress}:8080','/api/v1/schedule'),
        headers: {
          'Authorization': 'Bearer ${AuthService().accessToken}',
          'Content-Type': 'application/json'
        });

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('add depot point response: ${response.statusCode}');
      print(response.body);
    } else {
      return Future.error('error');
    }
  }
  
}