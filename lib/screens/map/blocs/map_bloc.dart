import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'map_event.dart';
import 'map_state.dart';
import 'package:location_repository/location_repository.dart';



class MapBloc extends Bloc<MapEvent, MapState>{
  final LocationRepository locationRepository;

  MapBloc({required this.locationRepository}) : super(MapInitial()) {
    on<LoadMap>(_onLoadMap);
    on<UpdateCameraPosition>(_onUpdateCameraPosition);
  }

  Future<void> _onLoadMap(LoadMap events, Emitter<MapState> emit) async {
    emit(MapLoading());
    try {
      final position = await locationRepository.getCurrentLocation();
      if (position == null){
        emit(const MapError('Location permission denied or unavailable.'));
      }else{
        emit(MapLoaded(position));
      }
    } catch (e){
      emit(MapError('Failed to load map: ${e.toString()}'));
    }
  }

  void _onUpdateCameraPosition(UpdateCameraPosition event, Emitter<MapState> emit){
    emit(MapLoaded(event.position));
  }
}