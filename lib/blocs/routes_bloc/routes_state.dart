abstract class RoutesState {}

class RoutesInitial extends RoutesState {}

class RoutesLoading extends RoutesState {}

class RoutesLoaded extends RoutesState {
  final String routeName;

  RoutesLoaded({required this.routeName});
}

class RoutesError extends RoutesState {
  final String message;

  RoutesError(this.message);
}
