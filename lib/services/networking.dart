import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkHelper {
  NetworkHelper(this.url);

  final String url;

  Future getData() async {
    http.Response response = await http.get(url);

    switch (response.statusCode) {
      case 200:
        String data = response.body;

        return jsonDecode(data);
      case 400:
        throw ('Malformed network request.');
      case 401:
      case 403:
      case 404:
        throw ('Unauthorized network request.');
      case 500:
      default:
        throw ('The service you are requesting is currently unavailable.');
    }
  }
}
