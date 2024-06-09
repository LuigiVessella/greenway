import 'dart:convert';

import 'package:greenway/dto/all_deliveries_dto.dart';
import 'package:greenway/entity/delivery.dart';
import 'package:greenway/services/network/data_providers/http_delivery_provider.dart';

class DeliveryRepository{
  
  ///http vehicle provider ci fornisce tutta la comunicazione con il server
  final HttpDeliveryResponse httpDelivery = HttpDeliveryResponse();



  void addNewDelivery(Delivery delivery) {
    httpDelivery.addDelivery(delivery);
  }

  void completeDelivery(String deliveryID) {
    httpDelivery.completeDelivery(deliveryID);
  }


  Future<void> addDepotPoint(){
    return httpDelivery.addDepotPoint();
  }


  Future<AllDeliveriesDTO> getAllDeliveries(int pageCounter)async {
    final response = await httpDelivery.getAllDeliveries(pageCounter);
    
    if(response.statusCode == 200 || response.statusCode == 201) {
      return AllDeliveriesDTO.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Failed to load deliveries');
    }

  }

}