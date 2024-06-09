import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:greenway/entity/delivery.dart';
import 'package:greenway/services/network/logger.dart';
import 'package:greenway/services/network/logger_web.dart';
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

  Future<void> addDepotPoint() async {
    final data = {
      "depositAddress": "Via Roma",
      "depositCoordinates": {
        "type": "Point",
        "coordinates": [14.266262, 40.884837]
      }
    };

    var response = await client.post(
      Uri.http('${dotenv.env['restApiEndpoint']}', '/api/v1/deposit'),
      headers: {
        'Authorization': 'Bearer ${AuthService().accessToken}',
        'Content-Type': 'application/json'
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('add depot point response: ${response.statusCode}');
      print(response.body);
    } else {
      return Future.error('error');
    }
  }

  Future<http.Response> getAllDeliveries(int pageCounter) async {
    String? accessToken =
        kIsWeb ? OIDCAuthService().accessToken : AuthService().accessToken;
    final params = {"pageNo": "$pageCounter", "pageSize": "10"};

    var response = await client.get(
      Uri.http(
          '${dotenv.env['restApiEndpoint']}', '/api/v1/deliveries', params),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
    );

    return response;
  }
}
