part of 'comment_cubit.dart';

sealed class CommentState extends Equatable {
  const CommentState();
}

final class CommentInitial extends CommentState {
  @override
  List<Object> get props => [];
}

class CommentLoading extends CommentState {
  @override
  List<Object> get props => [];
}

class CommentLoaded extends CommentState {
  final List<CommentEntity> comments;

  CommentLoaded({required this.comments});
  @override
  List<Object> get props => [comments];
}

class CommentFailure extends CommentState {
  @override
  List<Object> get props => [];
}
