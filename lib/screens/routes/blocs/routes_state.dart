import 'package:routes_repository/routes_repository.dart';

abstract class RoutesState {}

class RoutesLoading extends RoutesState{}

class RoutesLoaded extends RoutesState{
  final List<RouteModel> routes;
  RoutesLoaded(this.routes);
}

class RoutesError extends RoutesState{
  final String message;
  RoutesError(this.message);
}