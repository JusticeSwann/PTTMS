import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pttms/blocs/menu_bloc/menu_bloc.dart';


class BottomNavBarWidget extends StatelessWidget {
  const BottomNavBarWidget({ super.key });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => MenuBloc(),
      child: BlocBuilder<MenuBloc,MenuBlocState>(
        builder: (context, state) {
          if (state is SelectedIndexState){
            print('${state.selectedIndex}');
          }
          return BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home'
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.directions),
                label: 'Routes'
              ),
            ],
            onTap: (value) {
              context.read<MenuBloc>().add(MenuItemSelected(selectedIndex: value));
            },
          );
        },
      )
    );
  }
}
