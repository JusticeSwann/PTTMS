import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';


class MapPage extends StatefulWidget{
  const MapPage({super.key});

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  
  Location _locationController = new Location();

  static const LatLng _pUwi = LatLng(10.6416, -61.3995);
  static const LatLng _pCenterOfExcellence = LatLng(10.6408, -61.3824);
  LatLng? _currentP = null;

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _pUwi,
          zoom: 13,
          ),
        markers: {
          Marker(
            markerId: MarkerId("_currentLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: _pUwi),
          Marker(
            markerId: MarkerId("_sourceLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: _pCenterOfExcellence)
        },
      ),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled =  await _locationController.serviceEnabled();
    if (_serviceEnabled){
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationController.onLocationChanged.listen((LocationData _currentLocation){
      if (_currentLocation.latitude != null &&
       _currentLocation.longitude != null){
        setState(() {
          _currentP = LatLng(_currentLocation.latitude!, _currentLocation.longitude!);
          print(_currentP);
        });
      }
    });
  }
}