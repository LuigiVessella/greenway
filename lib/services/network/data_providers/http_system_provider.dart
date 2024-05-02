import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:greenway/services/network/logger.dart';
import 'package:http/http.dart' as http;

class HttpSystemResponse{
  final client = http.Client();

  Future<void> triggerDeliveryScheduling() async{
    var response = await client.get(
        Uri.http('${dotenv.env['restApiEndpoint']}','/api/v1/schedule'),
        headers: {
          'Authorization': 'Bearer ${AuthService().accessToken}',
          'Content-Type': 'application/json'
        });

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('add depot point response: ${response.statusCode}');
      print(response.body);
    } else {
      return Future.error('error');
    }
  }
  
}