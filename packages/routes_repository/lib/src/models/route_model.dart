class RouteModel {
  final String name;

  RouteModel({required this.name});

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(name: json['name']);
  }
}