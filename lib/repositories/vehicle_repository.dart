import 'package:greenway/dto/delivery_dman_dto.dart';
import 'package:greenway/dto/navigation_dto.dart';
import 'package:greenway/entity/vehicle/vehicle.dart';
import 'package:greenway/dto/vehicle_dto.dart';

import 'package:greenway/services/network/data_providers/http_vehicle_provider.dart';

class VehicleRepository {
  ///http vehicle provider ci fornisce tutta la comunicazione con il server
  HttpVehicleResponse httpVehicle = HttpVehicleResponse();

  Future<int> addVehicle(Vehicle vehicle) {
    return httpVehicle.addVehicle(vehicle);
  }

  Future<VehicleDto> getAllVehicles() {
    return httpVehicle.getAllVehicles();
  }


  Future<VehicleByDmanDto> getVehicleByDeliveryMan(String deliveryMan) {
    return httpVehicle.getVehicleByDeliveryMan(deliveryMan);
  }

  Future<NavigationDataDTO> getVehicleRoute(String vehicleID){
    return httpVehicle.getVehicleRoute(vehicleID);
  }
//
  // void updateVehicle(Vehicle vehicle) {
  //   httpVehicle.updateVehicle(vehicle);
  // }
//
  // void deleteVehicle(Vehicle vehicle) {
  //   httpVehicle.deleteVehicle(vehicle);
  // }
}
