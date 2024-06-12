import 'package:flutter/foundation.dart';
import 'package:greenway/config/ip_config.dart';
import 'package:greenway/services/network/logger.dart';
import 'package:greenway/services/network/logger_web.dart';
import 'package:http/http.dart' as http;

class HttpSystemResponse {
  final client = http.Client();

  Future<http.Response> triggerDeliveryScheduling() async {
    String? accessToken =
        kIsWeb ? OIDCAuthService().accessToken : AuthService().accessToken;
    var response = await client.get(
        Uri.http('${IpAddressManager().ipAddress}:8080', '/api/v1/schedule'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json'
        });

    return response;
  }
}
