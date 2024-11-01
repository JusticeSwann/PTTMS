import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routes_repository/routes_repository.dart';
import 'routes_event.dart';
import 'routes_state.dart';


class RoutesBloc extends Bloc<RoutesEvent,RoutesState>{
  final RoutesRepository routesRepository;

  RoutesBloc({required this.routesRepository}) : super(RoutesLoading()) {
    on<LoadRoutes>(_onLoadRoutes);
  }

  Future<void> _onLoadRoutes(LoadRoutes event, Emitter<RoutesState> emit) async {
    emit(RoutesLoading());
    try{
      final routes = await routesRepository.loadRoutes();
      emit(RoutesLoaded(routes));
    } catch (e) {
      emit(RoutesError('Failed to load routes'));
    }
  }
  
}