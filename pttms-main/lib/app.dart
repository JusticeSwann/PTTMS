import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pttms/blocs/menu_bloc/menu_bloc.dart';
import 'package:pttms/presentation/screens/home_page.dart';
import 'package:pttms/presentation/screens/routes_page.dart';
import 'package:pttms/presentation/widgets/bottom_navbar_widget.dart';

List<Widget> pages = [
  const HomePage(),
  const RoutesPage(),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuBloc(), 
      child: MaterialApp(
        home: Scaffold(
          body: BlocBuilder<MenuBloc, MenuState>(
            builder: (context, state) {
              if (state is SelectedIndexState) {
                return pages[state.selectedIndex];
              }
              return pages[0]; 
            },
          ),
          bottomNavigationBar: const BottomNavBarWidget(),
        ),
      ),
    );
  }
}
