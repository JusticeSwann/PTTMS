part of 'menu_bloc.dart';

sealed class MenuBlocState extends Equatable {
  const MenuBlocState();
  
  @override
  List<Object> get props => [];
}

class SelectedIndexState extends MenuBlocState{
  final int selectedIndex;
  const SelectedIndexState({required this.selectedIndex});

  @override
  List<Object> get props => [selectedIndex];
}

final class MenuBlocInitial extends MenuBlocState {}
