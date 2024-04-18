import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:greenway/dto/delivery_dman_dto.dart';
import 'package:greenway/dto/navigation_dto.dart';
import 'package:greenway/entity/vehicle/vehicle.dart';
import 'package:greenway/dto/vehicle_dto.dart';
import 'package:greenway/services/network/logger.dart';
import 'package:http/http.dart' as http;

class HttpVehicleResponse {
  var client = http.Client();

  Future<int> addVehicle(Vehicle vehicle) async {
    var response = await client.post(
        Uri.http('${dotenv.env['restApiEndpoint']}', '/api/v1/vehicles'),
        headers: {
          'Authorization': 'Bearer ${AuthService().accessToken}',
          'Content-Type': 'application/json'
        },
        body: vehicleToJson(vehicle));

        return response.statusCode;
  }

  Future<VehicleDto> getAllVehicles() async {
   
    final queryParams = {
      'pageNo': '0',
      'pageSize': '10',
    };

   // await Future.delayed(const Duration(seconds: 3));

    var response = await client.get(
        Uri.http('${dotenv.env['restApiEndpoint']}', '/api/v1/vehicles', queryParams),
        headers: {
          'Authorization': 'Bearer ${AuthService().accessToken}',
          'Content-Type': 'application/json'
      });


    return vehicleDtoFromJson(response.body);
  }

  Future<VehicleByDmanDto> getVehicleByDeliveryMan(String deliveryMan) async {

    var response = await client.get(
        Uri.http('${dotenv.env['restApiEndpoint']}','/api/v1/vehicles/deliveryman/$deliveryMan'),
        headers: {
          'Authorization': 'Bearer ${AuthService().accessToken}',
          'Content-Type': 'application/json'
        });

    print(response.statusCode);
    print(response.body);

    return vehicleByDmanDtoFromJson(response.body);
  }

  Future<NavigationDataDto> getVehicleRoute() async {
    var response = await client.get(
        Uri.http(
            '${dotenv.env['restApiEndpoint']}', '/api/v1/vehicles/1/route'),
        headers: {
          'Authorization': 'Bearer ${AuthService().accessToken}',
          'Content-Type': 'application/json'
        });

    return navigationDataDtoFromJson(response.body);
  }
}
