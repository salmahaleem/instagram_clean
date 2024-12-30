part of 'post_cubit.dart';

abstract class PostState extends Equatable {
  const PostState();
}

final class PostInitial extends PostState {
  @override
  List<Object> get props => [];
}

class PostLoading extends PostState {
  @override
  List<Object> get props => [];
}

class PostLoaded extends PostState {
  final List<PostEntity> posts;

  PostLoaded({required this.posts});
  @override
  List<Object> get props => [posts];
}

class PostSuccess extends PostState {
  final PostEntity post;

  PostSuccess({required this.post});
  @override
  List<Object> get props => [post];
}

class PostFailure extends PostState {
  @override
  List<Object> get props => [];
}
