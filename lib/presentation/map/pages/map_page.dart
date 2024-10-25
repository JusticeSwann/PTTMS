import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pttms/data/sources/location_service.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final LocationService _locationService = LocationService();
  late GoogleMapController _mapController;

  LatLng _initialPosition = const LatLng(10.6416, -61.3995); // Default position
  bool _isMapInitialized = false; // To ensure map only initializes once

  @override
  void initState() {
    super.initState();
    _setInitialLocation();
    _listenToLocationChanges();
  }

  /// Fetch and set the initial location only once.
  Future<void> _setInitialLocation() async {
    LocationData? locationData = await _locationService.getCurrentLocation();
    if (locationData != null) {
      setState(() {
        _initialPosition = LatLng(locationData.latitude!, locationData.longitude!);
      });
    }
  }

  /// Listen to location changes in the background without moving the camera.
  void _listenToLocationChanges() {
    _locationService.getLocationStream().listen((locationData) {
      LatLng newPosition = LatLng(locationData.latitude!, locationData.longitude!);
      print("New location: $newPosition"); // Log the new location data
    });
  }

  /// Callback for when the map is created.
  void _onMapCreated(GoogleMapController controller) {
    if (!_isMapInitialized) {
      _mapController = controller;
      _isMapInitialized = true;
      _moveCamera(_initialPosition);
    }
  }

  /// Move the camera to the given position.
  void _moveCamera(LatLng position) {
    _mapController.animateCamera(
      CameraUpdate.newLatLng(position),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 13,
        ),
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
      ),
    );
  }
}
