import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/domain/usecase/getSingleUser_usecase.dart';
import 'package:meta/meta.dart';

part 'get_single_user_state.dart';

class GetSingleUserCubit extends Cubit<GetSingleUserState> {
  final GetSingleUserUseCase getSingleUserUseCase;
  GetSingleUserCubit({required this.getSingleUserUseCase}) : super(GetSingleUserInitial());

  Future<void> getSingleUser({required String uid}) async {
    emit(GetSingleUserLoading());
    try {
      final streamResponse = await getSingleUserUseCase.call(uid);
      streamResponse.listen((users) {
        emit(GetSingleUserLoaded(user: users.first));
      });
    } on SocketException catch(_) {
      emit(GetSingleUserFailed());
    } catch (_) {
      emit(GetSingleUserFailed());
    }
  }
}
