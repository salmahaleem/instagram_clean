import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clean/feature/real/domain/entity/real_entity.dart';
import 'package:instagram_clean/feature/real/domain/usecase/read_single_real_usecase.dart';

part 'single_real_state.dart';

class SingleRealCubit extends Cubit<SingleRealState> {
  final ReadSingleRealUseCase readSingleRealUseCase;

  SingleRealCubit({required this.readSingleRealUseCase}) : super(SingleRealInitial());

  Future<void> getSingleReal({required String realId}) async {
    emit(SingleRealLoading());
    try {
      final streamResponse = readSingleRealUseCase.call(realId);
      streamResponse.listen((reals) {
        emit(SingleRealLoaded(real: reals.first));
      });
    } on SocketException catch(_) {
      emit(SingleRealFailure());
    } catch (_) {
      emit(SingleRealFailure());
    }
  }
}
