import 'package:greenway/entity/delivery.dart';
import 'package:greenway/services/network/logger.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HttpDeliveryResponse {
  final client = http.Client();

  Future<void> addDelivery(Delivery delivery) async {
    
    
    var response = await client.post(
        Uri.http('${dotenv.env['restApiEndpoint']}', '/api/v1/deliveries'),
        headers: {
          'Authorization': 'Bearer ${AuthService().accessToken}',
          'Content-Type': 'application/json'
        },
        body: DeliveryToJson(delivery));
    
    print(response.statusCode);
    print(response.body);
  }

  Future<List<Delivery>> getDeliveryByDeliveryMan(String deliveryManId) async {

    final queryParams ={
      'pageNo' : 0,
      'pageSize' : 5, 
    };

    var response = await client.get(
        Uri.http('${dotenv.env['restApiEndpoint']}', '/api/v1/deliveries/$deliveryManId', queryParams ),
        headers: {
          'Authorization': 'Bearer ${AuthService().accessToken}',
          'Content-Type': 'application/json'
        });

      List<Delivery> deliveries = DeliveriesFromJson(response.body);

      return deliveries;
        
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
