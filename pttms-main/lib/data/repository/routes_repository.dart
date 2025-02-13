import 'package:pttms/data/data_provider.dart';

class RoutesRepository {
  final RoutesDataProvider _dataProvider;

  RoutesRepository(this._dataProvider);

  Future<List<Map<String, dynamic>>> fetchRoutes() async {
    return await _dataProvider.getRoutes();
  }


  Future<List<String>> fetchRouteNames() async {
    final data = await _dataProvider.getRoutes();
    return data.map((route) => route['name'] as String).toList();
  }

  Future<List<String>> fetchRouteVehicleType() async {
    final data = await _dataProvider.getRoutes();
    return data.map((route) => route['vehicle_type'] as String).toList();
  }

}
