part of 'language_cubit.dart';

@immutable
sealed class LanguageState {}

final class LanguageInitial extends LanguageState {
  LanguageInitial();
}

final class LanguageChanged extends LanguageState {
  final Locale locale;
  LanguageChanged(this.locale);
}

