import 'dart:convert';

import 'package:greenway/entity/delivery.dart';
import 'package:http/http.dart' as http;

class HttpDeliveryResponse {
  var client = http.Client();

  Future<void> addDelivery(Delivery delivery) async {
    var response = await client
        .post(Uri.http('http://localhost:8080/api/v1/vehicles'), body: {
      'model': 'Tesla Model 3',
      'batteryNominalCapacity': '60.0',
      'vehicleConsumption': '139.0',
      'chargePortType': 'Type 2',
      'chargingPower': '11',
      'currentBatteryCharge': '100'
    });

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    var uri = Uri.parse(decodedResponse['uri'] as String);
    print(await client.get(uri));
    
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
