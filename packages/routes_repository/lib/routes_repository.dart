import 'dart:convert';
import 'package:flutter/services.dart';
import './src/models/models.dart';
export 'package:routes_repository/routes_repository.dart';
export './src/models/models.dart';

class RoutesRepository {
  Future<List<RouteModel>> loadRoutes() async {
    try {
      print('trying code');
      String jsonString = await rootBundle.loadString('routes.json');

      var jsonData = json.decode(jsonString);

      if (jsonData is List) {
        print('condition 1 ran');
        return jsonData.map((routeJson) => RouteModel.fromJson(routeJson)).toList();
      } else if (jsonData is Map) {
        print('condition 2 ran');
        RouteModel route = RouteModel.fromJson(jsonData);
        return [route];
      } else {
        print('condition 3 ran');
        return [];
      }
    } catch (e) {
      print('$e');
      return [];
    }
  }
}
