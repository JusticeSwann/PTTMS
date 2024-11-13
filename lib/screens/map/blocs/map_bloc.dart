import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'map_event.dart';
import 'map_state.dart';
import 'package:location_repository/location_repository.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationRepository locationRepository;
  Timer? _timer; // Timer for periodic location updates
  String? _deviceId;

  MapBloc({required this.locationRepository}) : super(MapInitial()) {
    _initialize(); // Call initialization function to set up device ID
    on<LoadMap>(_onLoadMap);
    on<UpdateCameraPosition>(_onUpdateCameraPosition);
  }

  // Initialization method to ensure device ID is available before processing events
  Future<void> _initialize() async {
    await _initDeviceId(); // Wait for device ID initialization to complete
    add(LoadMap()); // Trigger the LoadMap event once initialization is done
  }

  // Initialize device ID
  Future<void> _initDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (await deviceInfo.androidInfo != null) {
        final androidInfo = await deviceInfo.androidInfo;
        _deviceId = androidInfo.id; // Unique Android device ID
      } else if (await deviceInfo.iosInfo != null) {
        final iosInfo = await deviceInfo.iosInfo;
        _deviceId = iosInfo.identifierForVendor; // Unique iOS device ID
      }
      print('Device ID initialized: $_deviceId'); // Log the device ID for confirmation
    } catch (e) {
      print('Error initializing device ID: $e'); // Log any errors
    }
  }

  Future<void> _onLoadMap(LoadMap event, Emitter<MapState> emit) async {
    emit(MapLoading());
    try {
      final position = await locationRepository.getCurrentLocation();
      if (position == null) {
        emit(const MapError('Location permission denied or unavailable.'));
      } else {
        emit(MapLoaded(position));
        
        // Start periodic location saving every 10 seconds
        _startLocationSaving();
      }
    } catch (e) {
      emit(MapError('Failed to load map: ${e.toString()}'));
    }
  }

  void _onUpdateCameraPosition(UpdateCameraPosition event, Emitter<MapState> emit) {
    emit(MapLoaded(event.position));
  }

  void _startLocationSaving() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) async {
      try {
        final position = await locationRepository.getCurrentLocation();
        if (position != null && _deviceId != null) {
          await FirebaseFirestore.instance.collection('locations').add({
            'latitude': position.latitude,
            'longitude': position.longitude,
            'timestamp': FieldValue.serverTimestamp(),
            'device_id': _deviceId, 
          });
          print('Location saved: (${position.latitude}, ${position.longitude}) with device ID: $_deviceId');
        } else if (_deviceId == null) {
          print('Device ID not available. Skipping location save.');
        }
      } catch (e) {
        print('Error saving location to Firestore: $e');
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel(); // Stop the timer when the Bloc is closed
    return super.close();
  }
}
