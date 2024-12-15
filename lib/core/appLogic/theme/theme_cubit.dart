import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../shared/shared_pref.dart';
import '../../utils/styles.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial(AppTheme.lightTheme)){
    getTheme();
  }
  bool isMode = false;
  Future getTheme() async{
    var themeIndex = await SharedPref.getTheme();
    if(themeIndex == 0){
      emit(ThemeChanged(AppTheme.lightTheme));
    }
    else{
      emit(ThemeChanged(AppTheme.darkTheme));
    }
  }

  
  Future<void> saveTheme(Brightness brightness)async{
    final saveTheme = brightness == Brightness.light ? 0 : 1;
    await SharedPref.setTheme(saveTheme);
  }

  void themeToggle(){
    if(state.themeData.brightness == Brightness.light){
      emit(ThemeChanged(AppTheme.darkTheme));
      saveTheme(Brightness.dark);
    }
    else{
      emit(ThemeChanged(AppTheme.lightTheme));
      saveTheme(Brightness.light);
    }
  }
}




