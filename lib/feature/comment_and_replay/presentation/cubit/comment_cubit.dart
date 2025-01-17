import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clean/feature/comment_and_replay/domain/entity/comment_entity.dart';
import 'package:instagram_clean/feature/comment_and_replay/domain/usecase/comment_usecase/createComment_usecase.dart';
import 'package:instagram_clean/feature/comment_and_replay/domain/usecase/comment_usecase/deleteComment_usecase.dart';
import 'package:instagram_clean/feature/comment_and_replay/domain/usecase/comment_usecase/likeComment_usecase.dart';
import 'package:instagram_clean/feature/comment_and_replay/domain/usecase/comment_usecase/readComment_usecase.dart';
import 'package:instagram_clean/feature/comment_and_replay/domain/usecase/comment_usecase/updateComment_usecase.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final CreateCommentUseCase createCommentUseCase;
  final DeleteCommentUseCase deleteCommentUseCase;
  final LikeCommentUseCase likeCommentUseCase;
  final ReadCommentsUseCase readCommentsUseCase;
  final UpdateCommentUseCase updateCommentUseCase;

  CommentCubit({
    required this.updateCommentUseCase,
    required this.readCommentsUseCase,
    required this.likeCommentUseCase,
    required this.deleteCommentUseCase,
    required this.createCommentUseCase
  }) : super(CommentInitial());
  Future<void> getComments({required String postId}) async {
    emit(CommentLoading());
    try {
      final streamResponse = readCommentsUseCase.call(postId);
      streamResponse.listen((comments) {
        emit(CommentLoaded(comments: comments));
      });
    } on SocketException catch(_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }

  Future<void> likeComment({required CommentEntity comment}) async {
    try {
      await likeCommentUseCase.call(comment);
    } on SocketException catch(_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }

  Future<void> deleteComment({required CommentEntity comment}) async {
    try {
      await deleteCommentUseCase.call(comment);
    } on SocketException catch(_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }

  Future<void> createComment({required CommentEntity comment}) async {
    try {
      await createCommentUseCase.call(comment);
    } on SocketException catch(_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }

  Future<void> updateComment({required CommentEntity comment}) async {
    try {
      await updateCommentUseCase.call(comment);
    } on SocketException catch(_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }
}
