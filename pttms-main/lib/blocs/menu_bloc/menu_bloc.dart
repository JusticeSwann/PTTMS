import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'menu_bloc_event.dart';
part 'menu_bloc_state.dart';

class MenuBloc extends Bloc<MenuBlocEvent, MenuBlocState> {
  MenuBloc() : super(const SelectedIndexState(selectedIndex: 0)) {
    on<MenuItemSelected>((event, emit) {
      emit (SelectedIndexState(selectedIndex: event.selectedIndex));
    });
  }
}
