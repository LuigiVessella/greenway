import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:greenway/entity/vehicle.dart';
import 'package:greenway/entity/vehicleDTO.dart';
import 'package:greenway/services/network/logger.dart';
import 'package:http/http.dart' as http;

class HttpVehicleResponse {
  var client = http.Client();

  Future<void> addVehicle(Vehicle vehicle) async {
    var response = await client.post(
        Uri.http('${dotenv.env['restApiEndpoint']}', '/api/v1/vehicles'),
        headers: {
          'Authorization': 'Bearer ${AuthService().accessToken}',
          'Content-Type': 'application/json'
        },
        body: vehicleToJson(vehicle));

    print(response.statusCode);
    print(response.body);
  }

  Future<List<Vehicle>> getAllVehicles() async{

    await Future.delayed(const Duration(seconds: 3));

    var response = await client.get(Uri.http('${dotenv.env['restApiEndpoint']}', '/api/v1/vehicles'),
    headers: {
      'Authorization': 'Bearer ${AuthService().accessToken}',
      'Content-Type': 'application/json'
    });
    print(response.statusCode);
    print(response.body);
    
    
    
    return vehicleDtoFromJson(response.body).content;
    
  }

  //TODO:
  //Future<void> getVehicleById(String id) async {


}
