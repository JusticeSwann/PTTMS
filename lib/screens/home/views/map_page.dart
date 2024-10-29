import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static final LatLng _currentPossition = LatLng(10.6416, -61.3995);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPossition == null
        ? const Center(child: Text('Loading'))
        : GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPossition,
              zoom: 16,
            ),
        )
    );
  }
}