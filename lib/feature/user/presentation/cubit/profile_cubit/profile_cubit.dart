import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/domain/usecase/getAllUsers_usecase.dart';
import 'package:instagram_clean/feature/user/domain/usecase/logout_usecase.dart';
import 'package:instagram_clean/feature/user/domain/usecase/updateUser_usecase.dart';
import 'package:meta/meta.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final LogoutUseCase? logoutUseCase;
  final UpdateUserUseCase? updateUserUseCase;
  final GetAllUsersUseCase? getAllUsersUseCase;
  ProfileCubit({this.getAllUsersUseCase, this.updateUserUseCase, this.logoutUseCase}) : super(ProfileInitial());

  Future<void> getAllUsers({required UserEntity user}) async {
    emit(ProfileLoading());
    try {
      final streamResponse = getAllUsersUseCase!.call(user);
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
      await updateUserUseCase!.call(user);
    } on SocketException catch(_) {
      emit(ProfileFailed('error in update'));
    } catch (_) {
      emit(ProfileFailed('error in update'));
    }
  }

  Future<void> loggedOut()async {
    try {
      await logoutUseCase!.call();
      emit(ProfileClosed());
    } catch (_) {
      emit(ProfileClosed());
    }
  }
}
