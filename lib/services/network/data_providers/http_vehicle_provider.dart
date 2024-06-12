import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:greenway/config/ip_config.dart';
import 'package:greenway/entity/vehicle/vehicle.dart';
import 'package:greenway/services/network/logging/logger.dart';
import 'package:greenway/services/network/logging/logger_web.dart';
import 'package:http/http.dart' as http;

class HttpVehicleResponse {
  final client = http.Client();

  Future<http.Response> addVehicle(Vehicle vehicle) async {
    
    Future.delayed(Durations.short1);

    String? accessToken =
        kIsWeb ? OIDCAuthService().accessToken : AuthService().accessToken;

    var response = await client.post(
        Uri.http('${IpAddressManager().ipAddress}:8080', '/api/v1/vehicles'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json'
        },
        body: vehicleToJson(vehicle));

    return response;
  }

  Future<http.Response> getAllVehicles(int pageCounter) async {
    String? accessToken =
        kIsWeb ? OIDCAuthService().accessToken : AuthService().accessToken;

    final queryParams = {
      'pageNo': '$pageCounter',
      'pageSize': '10',
    };

    var response = await client.get(
        Uri.http('${IpAddressManager().ipAddress}:8080', '/api/v1/vehicles',
            queryParams),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods':
              'POST, GET, OPTIONS, PUT, DELETE, HEAD',
        });

    return response;
  }

  Future<http.Response> getVehicleByDeliveryMan(String deliveryMan) async {
    String? accessToken =
        kIsWeb ? OIDCAuthService().accessToken : AuthService().accessToken;
    var response = await client.get(
        Uri.http('${IpAddressManager().ipAddress}:8080',
            '/api/v1/vehicles/deliveryman/$deliveryMan'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json'
        });

    return response;
  }

  Future<http.Response> getVehicleRoute(String vehicleID) async {
    String? accessToken =
        kIsWeb ? OIDCAuthService().accessToken : AuthService().accessToken;

    var response = await client.get(
        Uri.http(
            '${IpAddressManager().ipAddress}:8080',
            'api/v1/vehicles/$vehicleID/route',
            {'navigationType': 'ELEVATION_OPTIMIZED'}),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json'
        });

    return response;
  }

  Future<http.Response> putLeaveVehicle(String vehicleID) async {
  String? accessToken =
        kIsWeb ? OIDCAuthService().accessToken : AuthService().accessToken;
    var response = await client.get(
        Uri.http('${IpAddressManager().ipAddress}:8080',
            'api/v1/vehicles/$vehicleID/leave'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json'
        });

    return response;
  }

  Future<http.Response> enterVehicle(String vehicleID) async {
  String? accessToken =
        kIsWeb ? OIDCAuthService().accessToken : AuthService().accessToken;
    var response = await client.get(
        Uri.http('${IpAddressManager().ipAddress}:8080',
            'api/v1/vehicles/$vehicleID/enter'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json'
        });
    print('enter vehicle ${response.statusCode}');

    return response;
  }

  Future<http.Response> getRoutesStandard(String vehicleID) async {
    String? accessToken =
        kIsWeb ? OIDCAuthService().accessToken : AuthService().accessToken;

    var response = await client.get(
        Uri.http('${IpAddressManager().ipAddress}:8080',
            'api/v1/vehicles/$vehicleID/route', {'navigationType': 'STANDARD'}),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json'
        });

    return response;
  }
}
