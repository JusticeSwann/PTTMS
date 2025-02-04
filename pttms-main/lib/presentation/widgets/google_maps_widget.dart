import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pttms/blocs/map_bloc/map_bloc.dart';

class GoogleMapsWidget extends StatefulWidget {
  const GoogleMapsWidget({ super.key });

  @override
  State<GoogleMapsWidget> createState() => _GoogleMapsWidgetState();
}

class _GoogleMapsWidgetState extends State<GoogleMapsWidget> {
  
  @override
  void initState() {
    super.initState();
    context.read<MapBloc>().add(MapLoad());
  }

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<MapBloc,MapState>(
      builder: (context, state) {
        if (state is MapLoading){
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MapLoaded){
          return GoogleMap(
            initialCameraPosition: CameraPosition(
            target: state.position,
            zoom: 15,
            ),
            mapType: MapType.normal,
            zoomControlsEnabled: false,
          );
        } else if (state is MapError){
          return const Center(
            child: Text('Error')
          );
        }
        return const Center(child: Text('Application Error'));
      },
    );
  }
}