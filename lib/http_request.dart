import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class HTTPRequest {
  final String subApi;
  final String? domain;
  final dynamic parameters;
  final String? category;
  final String? name;

  const HTTPRequest({
    this.domain,
    required this.subApi,
    this.parameters,
    this.category,
    this.name,
  });

  Future<dynamic> get() async {
    try {
      final uri = Uri.parse(APIConfig.domain + subApi);

      final response = await http.get(uri).timeout(const Duration(seconds: 20));

      print('response.statusCode ${response.statusCode} ');

      try {
        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        } else {
          return {
            "items": null,
            "success": false,
            "server_err": true,
            "msg":
                "Status code ${response.statusCode}! We're having trouble at the moment. Please try again later.",
          };
        }
      } catch (err) {
        return {
          "items": null,
          "success": false,
          "server_err": true,
          "msg": '$err',
        };
      }
    } catch (e) {
      print('easd $e');
      return {
        "items": null,
        "success": false,
        "server_err": false,
        "msg": "Please check your network settings or try again later.",
      };
    }
  }

  Future<dynamic> post() async {
    try {
      final uri = Uri.parse(APIConfig.domain + subApi);
      print('uri $uri');
      final response = await http
          .post(
            uri,
            headers: {"Content-Type": "application/json"},
            body: json.encode(parameters),
          )
          .timeout(Duration(seconds: 20));

      print('response.statusCode ${response.statusCode}');

      try {
        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        } else {
          return {
            "items": null,
            "success": false,
            "server_err": true,
            "msg":
                "Status code ${response.statusCode}! We're having trouble at the moment. Please try again later.",
          };
        }
      } catch (err) {
        return {
          "items": null,
          "success": false,
          "server_err": true,
          "msg": '$err',
        };
      }
    } catch (e) {
      return {
        "items": null,
        "success": false,
        "server_err": false,
        "msg": "Please check your network settings or try again later.",
      };
    }
  }
}
