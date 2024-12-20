part of 'get_other_single_user_cubit.dart';

@immutable
sealed class GetOtherSingleUserState {}

final class GetOtherSingleUserInitial extends GetOtherSingleUserState {}

final class GetOtherSingleUserLoading extends GetOtherSingleUserState {}

final class GetOtherSingleUserLoaded extends GetOtherSingleUserState {
  final UserEntity otherUser;

  GetOtherSingleUserLoaded({required this.otherUser});

}

final class GetOtherSingleUserFailed extends GetOtherSingleUserState {}

