import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/domain/usecase/getSingleOtherUser_usecase.dart';
import 'package:meta/meta.dart';

part 'get_other_single_user_state.dart';

class GetOtherSingleUserCubit extends Cubit<GetOtherSingleUserState> {
  final GetSingleOtherUserUseCase getSingleOtherUserUseCase;
  GetOtherSingleUserCubit({
    required this.getSingleOtherUserUseCase
  }) : super(GetOtherSingleUserInitial());

  Future<void> getSingleOtherUser({required String otherUid}) async {
    emit(GetOtherSingleUserLoading());
    try {
      final streamResponse = getSingleOtherUserUseCase.call(otherUid);
      streamResponse.listen((users) {
        emit(GetOtherSingleUserLoaded(otherUser: users.first));
      });
    } on SocketException catch(_) {
      emit(GetOtherSingleUserFailed());
    } catch (_) {
      emit(GetOtherSingleUserFailed());
    }
  }
}
