import '../data/data_provider.dart';

class RoutesRepository {
  final DataProvider _dataProvider;

  RoutesRepository(this._dataProvider);

  // Fetch only route names
  Future<List<String>> fetchRouteNames() async {
    final data = await _dataProvider.loadRoutesData();
    return data.map((route) => route['name'] as String).toList();
  }

  // Fetch full route data
  Future<List<Map<String, dynamic>>> fetchRoutes() async {
    return await _dataProvider.loadRoutesData(); // Return the full list of routes
  }
}
