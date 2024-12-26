part of 'sign_up_cubit.dart';

@immutable
sealed class SignUpState {}

final class SignUpInitial extends SignUpState {}

final class SignUpLoading extends SignUpState {}

final class SignUpSuccess extends SignUpState {
  final UserEntity user;

  SignUpSuccess(this.user);
}

final class SignUpFailed extends SignUpState {
  final String error;
  SignUpFailed(this.error);
}
