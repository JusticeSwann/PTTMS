part of 'menu_bloc.dart';

sealed class MenuBlocEvent extends Equatable {
  const MenuBlocEvent();

  @override
  List<Object> get props => [];
}

class MenuItemSelected extends MenuBlocEvent{
  final int selectedIndex;
  const MenuItemSelected({required this.selectedIndex});

  @override
  List<Object> get props => [selectedIndex];
}



