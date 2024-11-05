import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/routes/views/routes_page.dart';
import 'screens/map/views/map_page.dart';
import 'repositories/routes_repository.dart';
import 'data/data_provider.dart';
import 'blocs/routes_bloc/routes_bloc.dart';
import 'blocs/routes_bloc/routes_event.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Route Viewer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MapPage(), // Home page as MapPage
        '/routes': (context) => BlocProvider(
              create: (context) => RoutesBloc(
                RoutesRepository(DataProvider()), // Passes the repository with DataProvider dependency
              )..add(LoadRouteEvent()), // Loads route data when navigating to RoutesPage
              child: RoutesPage(),
            ),
      },
    );
  }
}
