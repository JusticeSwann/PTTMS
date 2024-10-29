import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../blocs/map_bloc.dart';
import '../blocs/map_event.dart';
import '../blocs/map_state.dart';
import 'package:location_repository/location_repository.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => LocationRepository(),  // Inject the LocationRepository
      child: BlocProvider(
        create: (context) => MapBloc(
          locationRepository: context.read<LocationRepository>(),
        )..add(LoadMap()),  // Trigger the LoadMap event on creation
        child: Scaffold(
          body: BlocBuilder<MapBloc, MapState>(
            builder: (context, state) {
              if (state is MapLoading) {
                return const Center(
                  child: CircularProgressIndicator(),  // Show loading spinner
                );
              } else if (state is MapLoaded) {
                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: state.position,  // User's location
                    zoom: 16,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                );
              } else if (state is MapError) {
                return Center(
                  child: Text(
                    state.message,  // Display error message
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else {
                return const Center(
                  child: Text('Initializing...'),  // Default fallback
                );
              }
            },
          ),
        ),
      ),
    );
  }
}