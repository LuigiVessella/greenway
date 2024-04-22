import 'package:greenway/services/network/data_providers/http_system_provider.dart';

class SystemRepository{
  final HttpSystemResponse httpSystemResponse = HttpSystemResponse();


  void trigDeliverySheduling(){
    httpSystemResponse.triggerDeliveryScheduling();
  }
}