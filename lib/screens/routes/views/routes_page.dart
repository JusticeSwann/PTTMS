import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/routes_bloc/routes_bloc.dart';
import '../../../blocs/routes_bloc/routes_event.dart';
import '../../../blocs/routes_bloc/routes_state.dart';
import '../../../repositories/routes_repository.dart';
import '../../../data/data_provider.dart';

class RoutesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Route Name'),
      ),
      body: BlocProvider(
        create: (context) => RoutesBloc(RoutesRepository(DataProvider()))..add(LoadRouteEvent()),
        child: BlocBuilder<RoutesBloc, RoutesState>(
          builder: (context, state) {
            if (state is RoutesLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is RoutesLoaded) {
              return Center(child: Text('Route Name: ${state.routeName}'));
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
