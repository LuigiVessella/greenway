import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:greenway/config/ip_config.dart';
import 'package:greenway/entity/delivery.dart';
import 'package:greenway/services/network/logger.dart';
import 'package:greenway/services/network/logger_web.dart';
import 'package:http/http.dart' as http;

class HttpDeliveryResponse {
  final client = http.Client();

  Future<void> addDelivery(Delivery delivery) async {
    String? accessToken =
        kIsWeb ? OIDCAuthService().accessToken : AuthService().accessToken;

    var response = await client.post(
        Uri.http('${IpAddressManager().ipAddress}:8080', '/api/v1/deliveries'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json'
        },
        body: deliveryToJson(delivery));

    print('add delivery response: ${response.statusCode}');
    print(response.body);
  }

  Future<http.Response> completeDelivery(String deliveryID) async {
    print('sono qui');
    String? accessToken =
        kIsWeb ? OIDCAuthService().accessToken : AuthService().accessToken;
    
    print(accessToken);

    var response = await client.get(
      Uri.http('${IpAddressManager().ipAddress}:8080',
          '/api/v1/deliveries/$deliveryID/complete'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
    );
    print(response.body);
    return response;
  }

  Future<http.Response> addDepotPoint(var data) async {
    String? accessToken =
        kIsWeb ? OIDCAuthService().accessToken : AuthService().accessToken;
    var response = await client.post(
      Uri.http('${IpAddressManager().ipAddress}:8080', '/api/v1/deposit'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
      body: json.encode(data),
    );

    print('depot ${response.statusCode}');

    return response;
  }

  Future<http.Response> updateDepotPoint(var data) async {
    String? accessToken =
        kIsWeb ? OIDCAuthService().accessToken : AuthService().accessToken;
    var response = await client.put(
      Uri.http('${IpAddressManager().ipAddress}:8080', '/api/v1/deposit'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
      body: json.encode(data),
    );

    print('depot update${response.statusCode}');

    return response;
  }

  Future<http.Response> getAllDeliveries(int pageCounter) async {
    String? accessToken =
        kIsWeb ? OIDCAuthService().accessToken : AuthService().accessToken;
    final params = {"pageNo": "$pageCounter", "pageSize": "10"};

    var response = await client.get(
      Uri.http(
          '${IpAddressManager().ipAddress}:8080', '/api/v1/deliveries', params),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
    );

    return response;
  }
}
