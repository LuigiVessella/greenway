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

  Future<void> addVehicle(Vehicle vehicle) async {
    final response = await httpVehicle.addVehicle(vehicle);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      return Future.error('error');
    }
  }

  Future<VehicleDto> getAllVehicles(int pagecounter) async {
    final response = await httpVehicle.getAllVehicles(pagecounter);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return VehicleDto.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      return Future.error('Non sei loggato: ${response.statusCode}');
    } else {
      return Future.error(
          'Non ci sono pacchi o veicoli associati: ${response.statusCode}');
    }
  }

  Future<VehicleByDmanDto> getVehicleByDeliveryMan(String deliveryMan) async {
    final response = await httpVehicle.getVehicleByDeliveryMan(deliveryMan);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return VehicleByDmanDto.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      return Future.error('Non sei loggato: ${response.statusCode}');
    } else {
      return Future.error(
          'Non ci sono pacchi o veicoli associati: ${response.statusCode}');
    }
  }

  Future<NavigationDataDTO> getVehicleRoute(String vehicleID) async {
    final response = await httpVehicle.getVehicleRoute(vehicleID);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return NavigationDataDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Errore route: ${response.statusCode}");
    }
  }

  Future<void> putLeaveVehicle(String vehicleID) async {
    final response = await httpVehicle.putLeaveVehicle(vehicleID);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      throw Exception("Errore: ${response.statusCode}");
    }
  }

  Future<List<NavigationDataDTO>> getVehicleRoutes(String vehicleID) async {
    final enterResponse = await httpVehicle.enterVehicle(vehicleID);

    if(enterResponse.statusCode != 200 && enterResponse.statusCode != 201) throw Exception("Errore enter: ${enterResponse.statusCode}");

    final responseStandard = await httpVehicle.getRoutesStandard(vehicleID);
    final responseElevation = await httpVehicle.getVehicleRoute(vehicleID);

    List<NavigationDataDTO> result = [];

    if (responseStandard.statusCode == 200 ||
        responseStandard.statusCode == 201) {
      print('standard ${responseStandard.statusCode}');
      result.add(NavigationDataDTO.fromJson(jsonDecode(responseStandard.body)));
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
