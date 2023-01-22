

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sendsms/screens/main/state/main_state.dart';


class MainCubit extends Cubit<MainState> {
  MainCubit() : super(StateFlag1());
  

  int currentpage = 0;


  pages(int index) {
    currentpage = index;
    if (index == 0) {
      emit(StateFlag1());
    } else if (index == 1) {
      emit(StateFlag2());
    } else if (index == 2) {
      emit(StateFlag3());
    } 
  }
}
