import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'menu_bloc_event.dart';
part 'menu_bloc_state.dart';

class MenuBlocBloc extends Bloc<MenuBlocEvent, MenuBlocState> {
  MenuBlocBloc() : super(MenuBlocInitial()) {
    on<MenuBlocEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
