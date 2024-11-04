import 'package:flutter/material.dart';
import 'package:routes_repository/routes_repository.dart'; // Adjust the import path as needed

class RoutesPage extends StatelessWidget {
  final RoutesRepository routesRepository = RoutesRepository();

  RoutesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Routes'),
      ),
      body: FutureBuilder<List<RouteModel>>(
        future: routesRepository.loadRoutes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No routes available'));
          } else {
            // Extract the route name
            final route = snapshot.data!.first;
            return Center(
              child: Text('Route Name: ${route.name}', style: const TextStyle(fontSize: 18)),
            );
          }
        },
      ),
    );
  }
}
