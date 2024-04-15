import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:greenway/dto/delivery_dman_dto.dart';
import 'package:greenway/services/network/logger.dart';
import 'package:http/http.dart' as http;

class HttpDeliveryManResponse {
  final client = http.Client();

  Future<void> createDeliveryMan() async {
    var response = await client.post(
        Uri.http('${dotenv.env['restApiEndpoint']}', '/api/v1/deliveryMen'),
        headers: {
          'Authorization': 'Bearer ${AuthService().accessToken}',
          'Content-Type': 'application/json'
        },
        body: null);

    print('Creazione deliveryman: ${response.statusCode}');
  }

  Future<List<DeliveryDmanDto>> getDeliveriesByDeliveryMan() async {

    final queryParams = {
      'pageNo': 0,
      'pageSize': 5,
    };

    var response = await client.get(
        Uri.http('${dotenv.env['restApiEndpoint']}', '/api/v1/deliveryMen', queryParams),
        headers: {
          'Authorization': 'Bearer ${AuthService().accessToken}',
          'Content-Type': 'application/json'
        });

        return deliveriesByDmanFromJson(response.body);
}
}