part of 'get_single_user_cubit.dart';

@immutable
sealed class GetSingleUserState {}

final class GetSingleUserInitial extends GetSingleUserState {}

final class GetSingleUserLoading extends GetSingleUserState {}

final class GetSingleUserLoaded extends GetSingleUserState {
  final UserEntity user;
  GetSingleUserLoaded({required this.user});
}

final class GetSingleUserFailed extends GetSingleUserState {}

