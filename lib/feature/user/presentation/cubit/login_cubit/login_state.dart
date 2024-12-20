part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final UserEntity user;
  LoginSuccess(this.user);
}

final class LoginFailed extends LoginState {
  final String error;
  LoginFailed(this.error);
}
