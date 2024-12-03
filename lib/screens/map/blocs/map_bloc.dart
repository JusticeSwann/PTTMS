import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
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
  String _status = 'passive'; // passive, waiting, or active
  int _statusTime = 0; // Time in seconds
  String? _currentRouteName; // Tracks the closest route name
  List<Map<String, dynamic>> _nearbyRoutes = []; // Routes within 300m

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
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      try {
        final position = await locationRepository.getCurrentLocation();
        if (position == null || _deviceId == null) {
          print('Location or device ID unavailable. Skipping upload.');
          return;
        }

        final routes = await _loadRoutesFromJson();

        // Reset nearby routes list and track the closest route
        _nearbyRoutes = [];
        String? closestRouteName;
        double minDistance = double.infinity;

        for (var route in routes) {
          final polyline = route['polyline'] as List;
          final parsedPolyline = polyline.map<List<double>>((point) {
            return List<double>.from(point);
          }).toList();

          final distance = _calculateMinDistanceToRoute(position, parsedPolyline);

          if (distance <= 300) {
            _nearbyRoutes.add({
              ...route,
              'polyline': parsedPolyline,
            });
            if (distance < minDistance) {
              minDistance = distance;
              closestRouteName = route['name'];
            }
          }
        }

        _currentRouteName = closestRouteName; // Set the closest route name

        print('Nearby Routes: ${_nearbyRoutes.map((route) => route['name']).toList()}');
        print('Closest Route: $_currentRouteName');

        // Update status based on proximity
        if (_nearbyRoutes.isEmpty) {
          _status = 'passive';
          print('No nearby routes. User status: $_status');
          return; // Do not upload data
        }

        final isNearPolyline = _nearbyRoutes.any((route) {
          final polyline = route['polyline'] as List<List<double>>;
          return _isNearRoute(position, polyline, distanceThreshold: 30);
        });

        if (isNearPolyline) {
          _status = 'waiting';
          _handleNearPickupPoint(position);
        } else {
          if (_lastPosition != null) {
            final distanceFromLastPosition = _calculateDistance(
              _lastPosition!.latitude,
              _lastPosition!.longitude,
              position.latitude,
              position.longitude,
            );
            if (distanceFromLastPosition >= 30) {
              _status = 'active';
            }
          }
        }

        if (_status != 'passive') {
          await FirebaseFirestore.instance.collection('locations').add({
            'latitude': position.latitude,
            'longitude': position.longitude,
            'timestamp': FieldValue.serverTimestamp(),
            'device_id': _deviceId,
            'status': _status,
            'status_time': _statusTime,
            'route_name': _currentRouteName,
          });
          print('Location saved: (${position.latitude}, ${position.longitude}), Status: $_status, Route: $_currentRouteName');
        }

        _lastPosition = position;
        _lastTimestamp = DateTime.now();
        _statusTime += 10;
      } catch (e) {
        print('Error saving location to Firestore: $e');
      }
    });
  }

  bool _isNearRoute(LatLng position, List<List<double>> polyline, {int distanceThreshold = 300}) {
    for (int i = 0; i < polyline.length - 1; i++) {
      final segmentStart = polyline[i];
      final segmentEnd = polyline[i + 1];
      final distance = _distanceToSegment(
        position.latitude,
        position.longitude,
        segmentStart[0],
        segmentStart[1],
        segmentEnd[0],
        segmentEnd[1],
      );
      if (distance <= distanceThreshold) {
        return true;
      }
    }
    return false;
  }

  double _calculateMinDistanceToRoute(LatLng position, List<List<double>> polyline) {
    double minDistance = double.infinity;
    for (int i = 0; i < polyline.length - 1; i++) {
      final segmentStart = polyline[i];
      final segmentEnd = polyline[i + 1];
      final distance = _distanceToSegment(
        position.latitude,
        position.longitude,
        segmentStart[0],
        segmentStart[1],
        segmentEnd[0],
        segmentEnd[1],
      );
      minDistance = min(minDistance, distance);
    }
    return minDistance;
  }

  double _distanceToSegment(
      double lat, double lon, double lat1, double lon1, double lat2, double lon2) {
    final p = [lat, lon];
    final v = [lat1, lon1];
    final w = [lat2, lon2];

    final l2 = pow(lat2 - lat1, 2) + pow(lon2 - lon1, 2);
    if (l2 == 0.0) return _calculateDistance(lat, lon, lat1, lon1);

    var t = ((p[0] - v[0]) * (w[0] - v[0]) + (p[1] - v[1]) * (w[1] - v[1])) / l2;
    t = max(0, min(1, t));

    final projection = [
      v[0] + t * (w[0] - v[0]),
      v[1] + t * (w[1] - v[1]),
    ];

    return _calculateDistance(lat, lon, projection[0], projection[1]);
  }

  Future<List<Map<String, dynamic>>> _loadRoutesFromJson() async {
    try {
      final String response = await rootBundle.loadString('assets/routes.json');
      final data = json.decode(response) as Map<String, dynamic>;
      final routes = (data['routes'] as List)
          .map((route) => route as Map<String, dynamic>)
          .toList();
      return routes;
    } catch (e) {
      print('Error loading routes.json: $e');
      return [];
    }
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
