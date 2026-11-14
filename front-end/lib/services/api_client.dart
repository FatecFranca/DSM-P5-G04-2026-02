
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ApiClient {
  static const Duration _timeout = Duration(seconds: 30);

  static Future<dynamic> get(String path) async {
    final response = await http
        .get(
          Uri.parse('${ApiConfig.baseUrl}$path'),
          headers: {
            'Content-Type': 'application/json',
          },
        )
        .timeout(_timeout);

    return _handleResponse(response);
  }

  static Future<dynamic> post(
    String path,
    Map<String, dynamic> data,
  ) async {
    final response = await http
        .post(
          Uri.parse('${ApiConfig.baseUrl}$path'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(data),
        )
        .timeout(_timeout);

    return _handleResponse(response);
  }

  static dynamic _handleResponse(http.Response response) {
    final body = response.body.isNotEmpty
        ? jsonDecode(response.body)
        : null;

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return body;
    }

    String message = 'Erro na comunicação com a API.';

    if (body is Map<String, dynamic>) {
      message = body['detail']?.toString() ?? message;
    }

    throw Exception(
      'Erro ${response.statusCode}: $message',
    );
  }
}
