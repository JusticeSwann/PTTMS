import '../data/data_provider.dart';

class RoutesRepository {
  final DataProvider _dataProvider;

  RoutesRepository(this._dataProvider);

  Future<String> fetchRouteName() async {
    final data = await _dataProvider.loadRoutesData();
    return data['name'] as String;  // Assuming "name" is the route name
  }
}
