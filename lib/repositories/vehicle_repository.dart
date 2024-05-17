import 'dart:async';
import 'dart:convert';

import 'package:greenway/dto/delivery_dman_dto.dart';
import 'package:greenway/dto/navigation_dto.dart';
import 'package:greenway/entity/vehicle/vehicle.dart';
import 'package:greenway/dto/vehicle_dto.dart';

import 'package:greenway/services/network/data_providers/http_vehicle_provider.dart';

class VehicleRepository {
  /// http vehicle response ci fornisce tutta la comunicazione con il server tramite http (REST API)
  HttpVehicleResponse httpVehicle = HttpVehicleResponse();

  Future<void> addVehicle(Vehicle vehicle) {
    return httpVehicle.addVehicle(vehicle);
  }

  Future<VehicleDto> getAllVehicles() {
    return httpVehicle.getAllVehicles();
  }

  Future<VehicleByDmanDto> getVehicleByDeliveryMan(String deliveryMan) {
    return httpVehicle.getVehicleByDeliveryMan(deliveryMan);
  }

  Future<NavigationDataDTO> getVehicleRoute(String vehicleID) async {
    httpVehicle.enterVehicle(vehicleID);
    final response = await httpVehicle.getVehicleRoute(vehicleID);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return NavigationDataDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Errore: ${response.statusCode}");
    }
  }

  void putLeaveVehicle(String vehicleID) {
    httpVehicle.putLeaveVehicle(vehicleID);
  }

  Future<List<NavigationDataDTO>> getVehicleRoutes(String vehicleID) async {
    final responseStandard = await httpVehicle.getRoutesStandard(vehicleID);
    final responseElevation = await httpVehicle.getVehicleRoute(vehicleID);

    List<NavigationDataDTO> result = [];

    if (responseStandard.statusCode == 200 ||
        responseStandard.statusCode == 201) {
          print('standard ${responseStandard.statusCode}');
      result
          .add(NavigationDataDTO.fromJson(jsonDecode(responseStandard.body)));
      if (responseElevation.statusCode == 200 ||
          responseElevation.statusCode == 201) {
            print('elevation ${responseElevation.statusCode}');
        result.add(
            NavigationDataDTO.fromJson(jsonDecode(responseElevation.body)));
      } else {
        throw Exception("Errore: ${responseElevation.statusCode}");
      }
      return result;
    } else {
      throw Exception("Errore: ${responseStandard.statusCode}");
    }
  }
}
