
class RouteModel {
  final String name;
  final String vehicleType;
  final List<List<double>> polyline;
  final List<double> routeStart;
  final List<double> routeEnd;
  final List<List<double>>? pickupPoints;

  RouteModel({
    required this.name,
    required this.vehicleType,
    required this.polyline,
    required this.routeStart,
    required this.routeEnd,
    required this.pickupPoints,
  });

  factory RouteModel.fromJson(Map<String,dynamic> json) {
    return RouteModel(
      name: json['name'] as String,
      vehicleType: json['vehileType'] as String,
      polyline: (json['polymap'] as List)
        .map((coords) => (coords as List).map((e) => e as double).toList())
        .toList(),
      routeStart: (json['route_start'] as List).map((e)=> e as double).toList(),
      routeEnd: (json['route_end'] as List).map((e) => e as double).toList(),
      pickupPoints: json['picup_points'] != null
        ? (json['pickup_points'] as List)
          .map((coords) => (coords as List).map((e) =>e as double).toList())
          .toList()
        : null,
    );
  }
}