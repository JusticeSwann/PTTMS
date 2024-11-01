export 'routes_repository.dart';
export './src/models/models.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import './src/models/models.dart';

class RoutesRepository {
  Future<List<RouteModel>> loadRoutes() async {

    List<RouteModel> routes = [];
    String jsonFilePath = 'lib/routes.json';

    String jsonString = await rootBundle.loadString(jsonFilePath);
    Map<String,dynamic> jsonData = json.decode(jsonString);
    routes.add(RouteModel.fromJson(jsonData));

    return routes;
  }
}