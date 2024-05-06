import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:greenway/dto/delivery_dman_dto.dart';
import 'package:greenway/dto/elevation_data_dto.dart';
import 'package:greenway/dto/navigation_dto.dart';
import 'package:greenway/entity/vehicle/vehicle.dart';
import 'package:greenway/dto/vehicle_dto.dart';
import 'package:greenway/services/network/logger.dart';
import 'package:greenway/services/network/logger_web.dart';
import 'package:http/http.dart' as http;

class HttpVehicleResponse {
  var client = http.Client();

  Future<void> addVehicle(Vehicle vehicle) async {
    Future.delayed(Durations.short1);
    try {
      String? accessToken =
          kIsWeb ? OIDCAuthService().accessToken : AuthService().accessToken;

      var response = await client.post(
          Uri.http('${dotenv.env['restApiEndpoint']}', '/api/v1/vehicles'),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json'
          },
          body: vehicleToJson(vehicle));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('add depot point response: ${response.statusCode}');
        print(response.body);
      } else {
        return Future.error('error');
      }
    } catch (e) {
      return Future.error('network error');
    }
  }

  Future<VehicleDto> getAllVehicles() async {
    String? accessToken =
        kIsWeb ? OIDCAuthService().accessToken : AuthService().accessToken;

    print(accessToken);
    final queryParams = {
      'pageNo': '0',
      'pageSize': '10',
    };

    // await Future.delayed(const Duration(seconds: 3));

    var response = await client.get(
        Uri.http('${dotenv.env['restApiEndpoint']}', '/api/v1/vehicles',
            queryParams),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': 'http://localhost:62033'
        });

    return VehicleDto.fromJson(jsonDecode(response.body));
  }

  Future<VehicleByDmanDto> getVehicleByDeliveryMan(String deliveryMan) async {
    var response = await client.get(
        Uri.http('${dotenv.env['restApiEndpoint']}',
            '/api/v1/vehicles/deliveryman/$deliveryMan'),
        headers: {
          'Authorization': 'Bearer ${AuthService().accessToken}',
          'Content-Type': 'application/json'
        });

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return VehicleByDmanDto.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      return Future.error('Non sei loggato: ${response.statusCode}');
    } else {
      return Future.error(
          'Non ci sono pacchi o veicoli associati: ${response.statusCode}');
    }
  }

  Future<NavigationDataDTO?> getVehicleRoute(String vehicleID) async {
    print(vehicleID);
    var response = await client.get(
        Uri.http('${dotenv.env['restApiEndpoint']}',
            'api/v1/vehicles/$vehicleID/route'),
        headers: {
          'Authorization': 'Bearer ${AuthService().accessToken}',
          'Content-Type': 'application/json'
        });

    print('Response vehicleroute ${response.statusCode}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return NavigationDataDTO.fromJson(jsonDecode(response.body));
    } else {
      return Future.error('Non ci sono consegne da mostrare!');
    }
  }

  Future<void> putLeaveVehicle(String vehicleID) async {
    var response = await client.get(
        Uri.http('${dotenv.env['restApiEndpoint']}',
            'api/v1/vehicles/$vehicleID/leave'),
        headers: {
          'Authorization': 'Bearer ${AuthService().accessToken}',
          'Content-Type': 'application/json'
        });

    print(response.statusCode);
    print(response.body);
  }

  Future<ElevationDataDTO> getElevationData(String vehicleID) async {
    var response = await client.get(
        Uri.http('${dotenv.env['restApiEndpoint']}',
            'api/v1/vehicles/$vehicleID/route/elevation'),
        headers: {
          'Authorization': 'Bearer ${AuthService().accessToken}',
          'Content-Type': 'application/json'
        });

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ElevationDataDTO.fromJson(jsonDecode(response.body));
    } else {
      return Future.error('Non ci sono consegne da mostrare!');
    }
  }
}
