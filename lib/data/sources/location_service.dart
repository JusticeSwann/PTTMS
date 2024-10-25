import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();

  LocationService() {
    _initialize();
  }

  Future<void> _initialize() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }
  }

  Future<LocationData?> getCurrentLocation() async {
    try {
      return await _location.getLocation();
    } catch (e) {
      print('Could not get current location: $e');
      return null;
    }
  }

  Stream<LocationData> getLocationStream() {
    return _location.onLocationChanged;
  }
}