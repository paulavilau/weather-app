import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkHelper {
  NetworkHelper(this.url); // Constructor care primește url-ul

  final String url;

  Future getData() async {
    // Efectuează o cerere GET la URL-ul specificat
    http.Response response = await http.get(
      Uri.parse(url),
    );

    // Verifică dacă cererea a avut succes (codul de stare 200)
    if (response.statusCode == 200) {
      String responseData = response.body;

      // Decodează stringul JSON în obiecte Dart și returnează rezultatul
      return jsonDecode(responseData);
    } else {
      print(response.statusCode);
    }
  }
}
