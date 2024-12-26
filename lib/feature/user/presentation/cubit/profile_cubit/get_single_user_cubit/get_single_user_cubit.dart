import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/domain/usecase/getSingleUser_usecase.dart';
import 'package:meta/meta.dart';

part 'get_single_user_state.dart';

class GetSingleUserCubit extends Cubit<GetSingleUserState> {
  final GetSingleUserUseCase getSingleUserUseCase;
  StreamSubscription<List<UserEntity>>? _subscription;

  GetSingleUserCubit({required this.getSingleUserUseCase}) : super(GetSingleUserInitial());

  Future<void> getSingleUser({required String uid}) async {
    emit(GetSingleUserLoading());
    try {
      final streamResponse = await getSingleUserUseCase.call(uid);
      _subscription = streamResponse.listen(
            (users) {
          if (users.isNotEmpty) {
            emit(GetSingleUserLoaded(user: users.first));
          } else {
            emit(GetSingleUserFailed("No users found for UID: $uid"));
          }
        },
        onError: (error) {
          emit(GetSingleUserFailed("Stream error: ${error.toString()}"));
        },
      );
    } on SocketException {
      emit(GetSingleUserFailed("No Internet connection."));
    } catch (error) {
      emit(GetSingleUserFailed("Unexpected error: ${error.toString()}"));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
