import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class DataProvider {
  Future<Map<String, dynamic>> loadRoutesData() async {
    final String jsonString = await rootBundle.loadString('assets/routes.json');
    return json.decode(jsonString);
  }
}
