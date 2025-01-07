import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clean/feature/real/domain/entity/real_entity.dart';
import 'package:instagram_clean/feature/real/domain/usecase/create_real_usecase.dart';
import 'package:instagram_clean/feature/real/domain/usecase/delete_real_usecase.dart';
import 'package:instagram_clean/feature/real/domain/usecase/like_real_usecase.dart';
import 'package:instagram_clean/feature/real/domain/usecase/read_reals_usecase.dart';
import 'package:instagram_clean/feature/real/domain/usecase/update_real_usecase.dart';

part 'real_state.dart';

class RealCubit extends Cubit<RealState> {
  final CreateRealUseCase createRealUseCase;
  final DeleteRealUseCase deleteRealUseCase;
  final LikeRealUseCase likeRealUseCase;
  final ReadRealsUseCase readRealUseCase;
  final UpdateRealUseCase updateRealUseCase;
  RealCubit({
    required this.createRealUseCase,
    required this.deleteRealUseCase,
    required this.likeRealUseCase,
    required this.readRealUseCase,
    required this.updateRealUseCase}) : super(RealInitial());

  Future<void> createReal({required RealEntity real}) async {
    emit(RealLoading());
    try {
      await createRealUseCase.call(real);
      emit(RealSuccess(real: real));
    } on SocketException catch(_) {
      emit(RealFailure());
    } catch (_) {
      emit(RealFailure());
    }
  }

  Future<void> likeReal({required RealEntity real}) async {
    try {
      await likeRealUseCase.call(real);
    } on SocketException catch(_) {
      emit(RealFailure());
    } catch (_) {
      emit(RealFailure());
    }
  }

  Future<void> updateReal({required RealEntity real}) async {
    try {
      await updateRealUseCase.call(real);
    } on SocketException catch(_) {
      emit(RealFailure());
    } catch (_) {
      emit(RealFailure());
    }
  }

  Future<void> deleteReal({required RealEntity real}) async {
    try {
      await deleteRealUseCase.call(real);
    } on SocketException catch(_) {
      emit(RealFailure());
    } catch (_) {
      emit(RealFailure());
    }
  }

  Future<void> getAllReals({required RealEntity real}) async {
    emit(RealLoading());
    try {
      final streamResponse = readRealUseCase.call(real);
      streamResponse.listen((reals) {
        emit(RealLoaded(reals: reals));
      });
    } on SocketException catch(_) {
      emit(RealFailure());
    } catch (_) {
      emit(RealFailure());
    }
  }
}
