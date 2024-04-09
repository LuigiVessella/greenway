import 'package:greenway/services/network/data_providers/http_deliveryman_provider.dart';

class DeliveryManRepository{
  final HttpDeliveryManResponse httpDeliveryManResponse = HttpDeliveryManResponse();

  void createDeliveryMan(){
    httpDeliveryManResponse.createDeliveryMan();
  }
}