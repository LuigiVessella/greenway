import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:greenway/services/network/logger.dart';
import 'package:http/http.dart' as http;

class HttpDeliveryManResponse{
  final client = http.Client();

  Future<void> createDeliveryMan() async {

    var response = await client.get(
      Uri.http('${dotenv.env['restApiEndpoint']}', '/api/v1/deliveryMen'),
        headers: {
          'Authorization': 'Bearer ${AuthService().accessToken}',
          'Content-Type': 'application/json'
        });


  }
}