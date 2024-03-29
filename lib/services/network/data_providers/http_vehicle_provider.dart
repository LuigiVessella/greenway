import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:greenway/entity/vehicle.dart';
import 'package:greenway/services/network/logger.dart';
import 'package:http/http.dart' as http;

class HttpVehicleResponse {
  var client = http.Client();

  Future<void> addVehicle(Vehicle vehicle) async {
    var response =
        await client.post(Uri.http('${dotenv.env['restApiEndpoint']}', '/api/v1/vehicles'),
            headers: {
              'Authorization': 'Bearer ${AuthService().accessToken}',
              'Content-Type': 'application/json'
            },
            body: jsonEncode({
              'model': 'Tesla Model 3',
              'batteryNominalCapacity': '60.0',
              'vehicleConsumption': '139.0',
              'currentBatteryCharge': '100',
              'maxCapacity': '100'
            }));
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
