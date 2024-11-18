import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'map_event.dart';
import 'map_state.dart';
import 'package:location_repository/location_repository.dart';
import 'dart:math';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationRepository locationRepository;
  Timer? _timer;
  String? _deviceId;

  MapBloc({required this.locationRepository}) : super(MapInitial()) {
    _initialize();
    on<LoadMap>(_onLoadMap);
    on<UpdateCameraPosition>(_onUpdateCameraPosition);
  }

  Future<void> _initialize() async {
    await _initDeviceId();
    add(LoadMap());
  }

  Future<void> _initDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      final androidInfo = await deviceInfo.androidInfo;
      _deviceId = androidInfo.id;
      print('Device ID initialized: $_deviceId');
    } catch (e) {
      print('Error initializing device ID: $e');
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
        if (position == null || _deviceId == null) {
          print('Location or device ID unavailable. Skipping upload.');
          return;
        }

        final pickupPoints = await _getCachedPickupPoints();
        if (pickupPoints.isEmpty) {
          print('No pickup points found. Ensure they are cached correctly.');
          return;
        }

        print('Checking proximity to pickup points...');
        final isNearby = pickupPoints.any((point) {
          final distance = _calculateDistance(
            position.latitude,
            position.longitude,
            point[0],
            point[1],
          );
          print('Distance to pickup point (${point[0]}, ${point[1]}): $distance meters');
          return distance <= 30;
        });

        if (!isNearby) {
          print('User is not near any pickup point. Current location: (${position.latitude}, ${position.longitude}).');
          return;
        }

        await FirebaseFirestore.instance.collection('locations').add({
          'latitude': position.latitude,
          'longitude': position.longitude,
          'timestamp': FieldValue.serverTimestamp(),
          'device_id': _deviceId,
        });
        print('Location saved: (${position.latitude}, ${position.longitude})');
      } catch (e) {
        print('Error saving location to Firestore: $e');
      }
    });
  }

Future<List<List<double>>> _getCachedPickupPoints() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Retrieve raw pickup points
  final rawPickupPoints = prefs.getStringList('pickupPoints') ?? [];
  print('Raw pickup points from SharedPreferences: $rawPickupPoints');

  // Parse and return pickup points
  return rawPickupPoints.map((point) {
    final coords = point.split(',');
    return [double.parse(coords[0]), double.parse(coords[1])];
  }).toList();
}


  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371000; // Earth's radius in meters
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
