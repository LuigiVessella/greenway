import 'package:greenway/entity/delivery.dart';
import 'package:greenway/services/network/logger.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HttpDeliveryResponse {
  final client = http.Client();

  Future<void> addDelivery(Delivery delivery) async {
    var response = await client.post(
        Uri.http('${dotenv.env['restApiEndpoint']}', '/api/v1/deliveries'),
        headers: {
          'Authorization': 'Bearer ${AuthService().accessToken}',
          'Content-Type': 'application/json'
        },
        body: deliveryToJson(delivery));

    print('add delivery response: ${response.statusCode}');
    print(response.body);
  }

  Future<void> completeDelivery(String deliveryID) async {
    var response = await client.get(
      Uri.http('${dotenv.env['restApiEndpoint']}',
          '/api/v1/deliveries/$deliveryID/complete'),
      headers: {
        'Authorization': 'Bearer ${AuthService().accessToken}',
        'Content-Type': 'application/json'
      },
    );
    print('Complete delivery response: ${response.statusCode}');
  }

  
}
