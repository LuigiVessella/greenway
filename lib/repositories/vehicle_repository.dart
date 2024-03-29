
import 'package:greenway/entity/vehicle.dart';

import 'package:greenway/services/network/data_providers/http_vehicle_provider.dart';

class VehicleRepository {
  HttpVehicleResponse httpVehicle = HttpVehicleResponse();



  void addVehicle(Vehicle vehicle) async{
    httpVehicle.addVehicle(vehicle);
  }
}
