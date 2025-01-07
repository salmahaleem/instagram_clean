import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/domain/usecase/followUnFollowUser_usecase.dart';
import 'package:instagram_clean/feature/user/domain/usecase/getAllUsers_usecase.dart';
import 'package:instagram_clean/feature/user/domain/usecase/logout_usecase.dart';
import 'package:instagram_clean/feature/user/domain/usecase/updateUser_usecase.dart';
import 'package:meta/meta.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final LogoutUseCase logoutUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final GetAllUsersUseCase getAllUsersUseCase;
  final FollowUnFollowUserUseCase followUnFollowUserUseCase;
  ProfileCubit({required this.followUnFollowUserUseCase, required this.getAllUsersUseCase, required this.updateUserUseCase,required this.logoutUseCase}) : super(ProfileInitial());

  Future<void> getAllUsers({required UserEntity user}) async {
    emit(ProfileLoading());
    try {
      final streamResponse = getAllUsersUseCase.call(user);
      streamResponse.listen((users) {
        emit(ProfileLoaded(users: users));
      });
    } on SocketException catch(_) {
      emit(ProfileFailed('error in get all users'));
    } catch (_) {
      emit(ProfileFailed('error in get all users'));
    }
  }

  Future<void> updateUser({required UserEntity user}) async {
    try {
      // Emit loading state to indicate update process has started
      emit(ProfileLoading());
      // Call the update method
      await updateUserUseCase.call(user);
    } on SocketException catch (_) {
      // Emit failure state with a specific network error message
      emit(ProfileFailed('No Internet connection. Please try again.'));
    } catch (e) {
      // Emit failure state with detailed error information
      emit(ProfileFailed('Failed to update profile: ${e.toString()}'));
    }
  }

  Future<void> loggedOut()async {
    try {
      await logoutUseCase.call();
      emit(ProfileClosed());
    } catch (_) {
      emit(ProfileClosed());
    }
  }

  Future<void> followUnFollowUser({required UserEntity user}) async {
    try {
      await followUnFollowUserUseCase.call(user);
    } on SocketException catch(_) {
      emit(ProfileFailed("error in follow button"));
    } catch (_) {
      emit(ProfileFailed("error in follow button"));
    }
  }
}
