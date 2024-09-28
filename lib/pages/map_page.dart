import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget{
  const MapPage({super.key});

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  
  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0849);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(initialCameraPosition: CameraPosition(
        target: _pGooglePlex,
        zoom: 13,
        ),
      ),
    );
  }
}