abstract class RoutesState {}

class RoutesInitial extends RoutesState {}

class RoutesLoading extends RoutesState {}

class RoutesLoaded extends RoutesState {
  final List<String> routeNames;

  RoutesLoaded({required this.routeNames});
}

class RoutesError extends RoutesState {
  final String message;

  RoutesError(this.message);
}
