part of 'theme_cubit.dart';

@immutable
sealed class ThemeState {
  final ThemeData themeData;
  ThemeState(this.themeData);
}

final class ThemeInitial extends ThemeState {
  ThemeInitial(ThemeData lightTheme):super(lightTheme);
}

final class ThemeChanged extends ThemeState {
  ThemeChanged(ThemeData themeData):super(themeData);
}


final class ThemeToggle extends ThemeState {
  final bool isMode;
  ThemeToggle(ThemeData themeData,this.isMode) : super(themeData);
}