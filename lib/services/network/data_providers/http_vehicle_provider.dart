import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:greenway/entity/vehicle.dart';
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
        body: VehicleToJson(vehicle));

    print(response.statusCode);
    print(response.body);
  }
  //}
  //Future<void> deleteDelivery(Delivery delivery){

  //}
  //Future<void> updateDelivery(Delivery delivery){

  //}
  //Future<List<Delivery>> getDelivery(){
  //
  //}

  //factory DeliveryRepositories.fromJSon(Map<String, dynamic> data) {
  //  return
  //}
}
