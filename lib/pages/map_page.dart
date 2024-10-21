import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  final Location _locationController = Location();
  static const LatLng _pUwi = LatLng(10.6416, -61.3995);
  static const LatLng _pCenterOfExcellence = LatLng(10.6408, -61.3824);
  LatLng? _currentP;

  late Stream<LocationData> _locationStream;

  @override
  void initState() {
    super.initState();
    _locationStream = _locationController.onLocationChanged;
    getLocationUpdates();
  }

  @override
  void dispose() {
    _locationController.onLocationChanged.drain(); // Prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Maps Example')),
      body: _currentP == null
          ? const Center(child: Text('Loading...'))
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentP!,
                zoom: 16,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId("_currentLocation"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure),
                  position: _currentP!,
                ),
                const Marker(
                  markerId: MarkerId("_sourceLocation1"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: _pUwi,
                ),
                const Marker(
                  markerId: MarkerId("_sourceLocation2"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: _pCenterOfExcellence,
                ),
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddRouteOverlay(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.grey[300],
        elevation: 5,
      ),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationStream.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        setState(() {
          _currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          print(_currentP);
        });
      }
    });
  }

  void _showAddRouteOverlay(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return const AddRouteOverlay();
      },
    );
  }
}

class AddRouteOverlay extends StatefulWidget {
  const AddRouteOverlay({super.key});

  @override
  _AddRouteOverlayState createState() => _AddRouteOverlayState();
}

class _AddRouteOverlayState extends State<AddRouteOverlay> {
  String? _selectedTransportMode = 'Bus'; // Default selected mode

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Pickup and Destination',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildLocationTextField('Select Pickup'),
                const SizedBox(height: 8),
                _buildLocationTextField('Select Destination'),
                const SizedBox(height: 16),
                _buildTransportModeSelector(),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the overlay
                  },
                  child: const Text('Confirm Route'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLocationTextField(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildTransportModeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTransportIcon(Icons.directions_bus, 'Bus'),
        _buildTransportIcon(Icons.directions_transit, 'Maxi'),
        _buildTransportIcon(Icons.local_taxi, 'Taxi'),
      ],
    );
  }

  Widget _buildTransportIcon(IconData icon, String mode) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTransportMode = mode;
        });
      },
      child: Column(
        children: [
          Icon(
            icon,
            size: 40,
            color: _selectedTransportMode == mode
                ? Colors.red
                : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            mode,
            style: TextStyle(
              color: _selectedTransportMode == mode
                  ? Colors.red
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
