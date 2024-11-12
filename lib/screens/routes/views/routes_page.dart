import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../blocs/routes_bloc/routes_bloc.dart';
import '../../../blocs/routes_bloc/routes_event.dart';
import '../../../blocs/routes_bloc/routes_state.dart';
import '../../../repositories/routes_repository.dart';
import '../../../data/data_provider.dart';

class RoutesPage extends StatefulWidget {
  @override
  _RoutesPageState createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  String? selectedRoute;
  List<String> availableRoutes = [];
  List<String> selectedRoutes = [];

  @override
  void initState() {
    super.initState();
    _loadSelectedRoutes();
  }

  // Load selected routes from SharedPreferences
  Future<void> _loadSelectedRoutes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedSelectedRoutes = prefs.getStringList('selectedRoutes');
    if (savedSelectedRoutes != null) {
      setState(() {
        selectedRoutes = savedSelectedRoutes;
      });
    }
  }

  // Save selected routes to SharedPreferences
  Future<void> _saveSelectedRoutes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selectedRoutes', selectedRoutes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Routes Selection'),
      ),
      body: BlocProvider(
        create: (context) => RoutesBloc(RoutesRepository(DataProvider()))..add(LoadRouteEvent()),
        child: BlocBuilder<RoutesBloc, RoutesState>(
          builder: (context, state) {
            if (state is RoutesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RoutesLoaded) {
              // Populate available routes only once on successful load
              if (availableRoutes.isEmpty) {
                availableRoutes = state.routeNames
                    .where((route) => !selectedRoutes.contains(route))
                    .toList();
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity, // Matches card width
                      height: 60, // Slightly taller than default
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        hint: const Text('Select a route'),
                        value: selectedRoute,
                        isExpanded: true,
                        underline: const SizedBox(), // Remove default underline
                        items: availableRoutes.map((route) {
                          return DropdownMenuItem<String>(
                            value: route,
                            child: Text(route),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedRoute = value;
                            if (value != null) {
                              selectedRoutes.add(value);
                              availableRoutes.remove(value);
                              _saveSelectedRoutes(); // Save to preferences
                            }
                            selectedRoute = null;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: selectedRoutes.length,
                        itemBuilder: (context, index) {
                          final route = selectedRoutes[index];
                          return Card(
                            child: ListTile(
                              title: Text(route),
                              trailing: IconButton(
                                icon: const Icon(Icons.remove_circle),
                                color: Colors.red,
                                onPressed: () {
                                  setState(() {
                                    selectedRoutes.remove(route);
                                    availableRoutes.add(route);
                                    _saveSelectedRoutes(); // Update preferences
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is RoutesError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
