import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'route_event.dart';
part 'route_state.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  RouteBloc() : super(const RouteVehicleState(vehicleType: [true,false,false], vehicleTypeIndex: 0)) {
    
    on<RoutesPageLoaded>((event, emit) {
      
    });

    on<VehicleTypeSelected>((event, emit) {
      _onVehicleTypeSelected(event,emit);
    });

    on<RouteSelected>((event, emit) {

    });

    on<RouteRemoved>((event, emit) {
      
    },);

  }
}

void _onVehicleTypeSelected(VehicleTypeSelected event, Emitter<RouteState> emit) {

  List<bool> updatedVehicleType = List.generate(
    event.vehicleType.length,
    (index) => index == event.vehicleTypeIndex,
  );

  emit(RouteVehicleState(vehicleType: updatedVehicleType, vehicleTypeIndex: event.vehicleTypeIndex));

}



