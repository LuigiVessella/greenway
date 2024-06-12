import 'package:greenway/services/network/data_providers/http_system_provider.dart';
import 'package:http/http.dart' as http;

class SystemRepository {
  final HttpSystemResponse httpSystemResponse = HttpSystemResponse();

  Future<http.Response> trigDeliverySheduling() async {
    final response = await httpSystemResponse.triggerDeliveryScheduling();

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } else {
      return Future.error('${response.statusCode}');
    }
  }
}
