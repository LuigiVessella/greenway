import 'package:greenway/entity/vehicle.dart';

import 'package:greenway/services/network/data_providers/http_vehicle_provider.dart';

class VehicleRepository {
  ///http vehicle provider ci fornisce tutta la comunicazione con il server
  HttpVehicleResponse httpVehicle = HttpVehicleResponse();

  void addVehicle(Vehicle vehicle) {
    httpVehicle.addVehicle(vehicle);
  }

  Future<List<Vehicle>> getAllVehicles() {
    print(httpVehicle.getAllVehicles());
    return httpVehicle.getAllVehicles();
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
