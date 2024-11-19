import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'map_event.dart';
import 'map_state.dart';
import 'package:location_repository/location_repository.dart';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationRepository locationRepository;
  Timer? _timer;
  String? _deviceId;
  DateTime? _nearPickupStartTime;
  LatLng? _lastPosition;
  DateTime? _lastTimestamp;
  String _status = 'waiting'; // waiting or moving
  int _statusTime = 0; // Time in seconds
  String _routeName = 'Default Route'; // Placeholder for route name

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

        // Check proximity to pickup points
        final isNearby = pickupPoints.any((point) {
          final distance = _calculateDistance(
            position.latitude,
            position.longitude,
            point[0],
            point[1],
          );
          return distance <= 30;
        });

        if (isNearby) {
          _handleNearPickupPoint(position);
        } else {
          _nearPickupStartTime = null; // Reset timer if no longer near a pickup point
          _status = 'moving';
        }

        // Calculate speed
        double speed = 0;
        if (_lastPosition != null && _lastTimestamp != null) {
          final timeDiff = DateTime.now().difference(_lastTimestamp!).inSeconds;
          final distance = _calculateDistance(
            _lastPosition!.latitude,
            _lastPosition!.longitude,
            position.latitude,
            position.longitude,
          );
          speed = distance / timeDiff; // Speed in m/s (~3.6 for km/h)

          if (speed > 4.2) {
            print('User moving at speed ${speed * 3.6} km/h. Continuing tracking.');
            _status = 'moving';
          } else {
            print('User moving below 15 km/h. Checking distance from route...');
            _status = 'waiting';
          }
        }

        // Calculate distance from route
        final isOnRoute = _isOnRoute(position, pickupPoints);
        final distanceFromRoute = isOnRoute
            ? 0
            : _calculateNearestDistance(position, pickupPoints);

        if (!isOnRoute) {
          print('User moved more than 30m away from the route. Stopping tracking.');
          _timer?.cancel();
          return;
        }

        // Save location to Firestore
        await FirebaseFirestore.instance.collection('locations').add({
          'latitude': position.latitude,
          'longitude': position.longitude,
          'timestamp': FieldValue.serverTimestamp(),
          'device_id': _deviceId,
          'route_name': _routeName,
          'status': _status,
          'status_time': _statusTime,
          'distance_from_route': distanceFromRoute,
        });
        print(
            'Location saved: (${position.latitude}, ${position.longitude}), Status: $_status, Distance from Route: $distanceFromRoute');

        // Update last position, timestamp, and status time
        _lastPosition = position;
        _lastTimestamp = DateTime.now();
        _statusTime += 10; // Increment status time every 10 seconds
      } catch (e) {
        print('Error saving location to Firestore: $e');
      }
    });
  }

  void _handleNearPickupPoint(LatLng position) {
    if (_nearPickupStartTime == null) {
      _nearPickupStartTime = DateTime.now();
      print('User near pickup point. Timer started.');
    } else {
      final duration = DateTime.now().difference(_nearPickupStartTime!);
      print('User near pickup point for ${duration.inSeconds} seconds.');
      _statusTime = duration.inSeconds;
    }
  }

  bool _isOnRoute(LatLng position, List<List<double>> routePolyline) {
    return routePolyline.any((point) {
      final distance = _calculateDistance(
        position.latitude,
        position.longitude,
        point[0],
        point[1],
      );
      return distance <= 30;
    });
  }

  double _calculateNearestDistance(LatLng position, List<List<double>> routePolyline) {
    return routePolyline
        .map((point) => _calculateDistance(
              position.latitude,
              position.longitude,
              point[0],
              point[1],
            ))
        .reduce(min);
  }

  Future<List<List<double>>> _getCachedPickupPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final rawPickupPoints = prefs.getStringList('pickupPoints') ?? [];
    return rawPickupPoints.map((point) {
      final coords = point.split(',');
      return [double.parse(coords[0]), double.parse(coords[1])];
    }).toList();
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371000;
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
