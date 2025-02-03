part of 'menu_bloc_bloc.dart';

sealed class MenuBlocState extends Equatable {
  const MenuBlocState();
  
  @override
  List<Object> get props => [];
}

final class MenuBlocInitial extends MenuBlocState {}
