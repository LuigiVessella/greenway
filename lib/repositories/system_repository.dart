import 'package:greenway/services/network/data_providers/http_system_provider.dart';

class SystemRepository{
  final HttpSystemResponse httpSystemResponse = HttpSystemResponse();


  Future<void> trigDeliverySheduling(){
    return httpSystemResponse.triggerDeliveryScheduling();
  }
}