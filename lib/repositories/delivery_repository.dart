import 'dart:convert';

import 'package:greenway/dto/all_deliveries_dto.dart';
import 'package:greenway/entity/delivery.dart';
import 'package:greenway/services/network/data_providers/http_delivery_provider.dart';
import 'package:http/http.dart' as http;

class DeliveryRepository {
  ///http vehicle provider ci fornisce tutta la comunicazione con il server
  final HttpDeliveryResponse httpDelivery = HttpDeliveryResponse();

  Future<http.Response> addNewDelivery(Delivery delivery) async {
    final response = await httpDelivery.addDelivery(delivery);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } else {
      throw Exception('$response');
    }
  }

  Future<http.Response> completeDelivery(String deliveryID) async {
    final response = await httpDelivery.completeDelivery(deliveryID);
    print('response: ${response.statusCode}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } else {
      throw Exception('$response');
    }
  }

  Future<http.Response> addDepotPoint(var data) async {
    final response = await httpDelivery.addDepotPoint(data);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } else if (response.statusCode == 208) {
      final responseUpdate = await httpDelivery.updateDepotPoint(data);
      if (responseUpdate.statusCode == 200 ||
          responseUpdate.statusCode == 201) {
        return response;
      } else {
        throw Exception('$responseUpdate');
      }
    } else
      throw Exception('$response');
  }

  Future<AllDeliveriesDTO> getAllDeliveries(int pageCounter) async {
    final response = await httpDelivery.getAllDeliveries(pageCounter);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AllDeliveriesDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load deliveries');
    }
  }
}
