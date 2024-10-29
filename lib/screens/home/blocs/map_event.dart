import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapEvent extends Equatable{
  const MapEvent();

  @override
  List<Object> get props => [];
}

class LoadMap extends MapEvent{}

class UpdateCameraPosition extends MapEvent{
  final LatLng position;

  const UpdateCameraPosition(this.position);
  
  @override
  List<Object> get props => [position];
}