import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clean/feature/comment_and_replay/domain/entity/replay_entity.dart';
import '../../../domain/usecase/replay_usecase/create_replay_usecase.dart';
import '../../../domain/usecase/replay_usecase/delete_replay_usecase.dart';
import '../../../domain/usecase/replay_usecase/like_replay_usecase.dart';
import '../../../domain/usecase/replay_usecase/read_replay_usecase.dart';
import '../../../domain/usecase/replay_usecase/update_replay_usecase.dart';

part 'replay_state.dart';

class ReplayCubit extends Cubit<ReplayState> {
  final CreateReplayUseCase createReplayUseCase;
  final DeleteReplayUseCase deleteReplayUseCase;
  final LikeReplayUseCase likeReplayUseCase;
  final ReadReplaysUseCase readReplaysUseCase;
  final UpdateReplayUseCase updateReplayUseCase;
  ReplayCubit({required this.createReplayUseCase,required this.deleteReplayUseCase, required this.likeReplayUseCase,required this.readReplaysUseCase, required this.updateReplayUseCase}) : super(ReplayInitial());

  Future<void> getReplays({required ReplayEntity replay}) async {
    emit(ReplayLoading());
    try {
      final streamResponse = readReplaysUseCase.call(replay);
      streamResponse.listen((replays) {
        emit(ReplayLoaded(replays: replays));
      });
    } on SocketException catch(_) {
      emit(ReplayFailure());
    } catch (_) {
      emit(ReplayFailure());
    }
  }

  Future<void> likeReplay({required ReplayEntity replay}) async {
    try {
      await likeReplayUseCase.call(replay);
    } on SocketException catch(_) {
      emit(ReplayFailure());
    } catch (_) {
      emit(ReplayFailure());
    }
  }

  Future<void> createReplay({required ReplayEntity replay}) async {
    try {
      await createReplayUseCase.call(replay);
    } on SocketException catch(_) {
      emit(ReplayFailure());
    } catch (_) {
      emit(ReplayFailure());
    }
  }

  Future<void> deleteReplay({required ReplayEntity replay}) async {
    try {
      await deleteReplayUseCase.call(replay);
    } on SocketException catch(_) {
      emit(ReplayFailure());
    } catch (_) {
      emit(ReplayFailure());
    }
  }

  Future<void> updateReplay({required ReplayEntity replay}) async {
    try {
      await updateReplayUseCase.call(replay);
    } on SocketException catch(_) {
      emit(ReplayFailure());
    } catch (_) {
      emit(ReplayFailure());
    }
  }
}
