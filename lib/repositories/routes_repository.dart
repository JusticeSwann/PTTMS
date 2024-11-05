import '../data/data_provider.dart';

class RoutesRepository {
  final DataProvider _dataProvider;

  RoutesRepository(this._dataProvider);

  Future<List<String>> fetchRouteNames() async {
    final data = await _dataProvider.loadRoutesData();
    return data.map((route) => route['name'] as String).toList();
  }
}
