part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final List<UserEntity> users;
  ProfileLoaded({required this.users});
}

final class ProfileUpdated extends ProfileState {}

final class ProfileClosed extends ProfileState {}

final class ProfileFailed extends ProfileState {
  final String error;

  ProfileFailed(this.error);

}

