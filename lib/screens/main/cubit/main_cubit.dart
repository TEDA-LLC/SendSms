

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sendsms/screens/main/state/main_state.dart';


class MainCubit extends Cubit<MainState> {
  MainCubit() : super(StateFlag1());
  

  int currentpage = 0;

  changeCurrentPage(int i){
   currentpage = i;
   emit(StateFlag3());
  }
  bool serLoc = true;
  int serverChek  = 1;
  pages(int index) {
    currentpage = index;
    if (index == 0) {
      emit(StateFlag1());
    } else if (index == 1) {
      emit(StateFlag2());
    } else if (index == 2) {
      emit(StateFlag3());
    } else if (index == 3) {
      emit(StateFlag4());
    } 
  }



  changeSmsView(bool trueFalse){
    serLoc = trueFalse;
  }
  

  serverCheking(int i){
    serverChek = i;
  }
}
