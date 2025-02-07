import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pttms/data/data_provider.dart';
import 'package:pttms/data/repository/routes_repository.dart';

part 'route_event.dart';
part 'route_state.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  RouteBloc() : super(const RouteVehicleState(vehicleType: [true,false,false], vehicleTypeIndex: 0)) {

    on<VehicleTypeSelected>((event, emit) {
      _onVehicleTypeSelected(event,emit);
    });

    on<RouteLoadEvent>((event, emit) {
      _onRouteLoadEvent;
    });
  }
  void _onVehicleTypeSelected(VehicleTypeSelected event, Emitter<RouteState> emit) {
    List<bool> updatedVehicleType = List.generate(
      event.vehicleType.length,
      (index) => index == event.vehicleTypeIndex,
    );
    emit(RouteVehicleState(vehicleType: updatedVehicleType, vehicleTypeIndex: event.vehicleTypeIndex));
  }

  Future<void> _onRouteLoadEvent(RouteLoadEvent event, Emitter<RouteState> emit) async {
    emit(RoutesLoading());
    try{
      final RoutesRepository routesRepository = RoutesRepository(RoutesDataProvider());
      final routes = await routesRepository.fetchRoutes();
      emit(RoutesLoaded(availableRoutes: routes));
    } catch (e) {
      emit(const RoutesLoadError('Failed to load Routes'));
    }
  }
}


