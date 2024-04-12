import 'package:greenway/entity/delivery.dart';
import 'package:greenway/services/network/data_providers/http_delivery_provider.dart';

class DeliveryRepository{
  
  ///http vehicle provider ci fornisce tutta la comunicazione con il server
  final HttpDeliveryResponse httpDelivery = HttpDeliveryResponse();



  void addNewDelivery(Delivery delivery) {
    httpDelivery.addDelivery(delivery);
  }


  Future<List<Delivery>> getDeliveryByDeliveryMan(String deliveryManId) {
    return httpDelivery.getDeliveryByDeliveryMan(deliveryManId);
  }
}