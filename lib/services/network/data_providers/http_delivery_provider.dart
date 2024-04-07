import 'dart:convert';

import 'package:greenway/entity/delivery.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HttpDeliveryResponse {
  var client = http.Client();

  Future<void> addDelivery(Delivery delivery) async {
    var response = await client
        .post(Uri.http('${dotenv.env['restApiEndpoint']}'), body: {
    
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
