part of 'single_post_cubit.dart';

abstract class SinglePostState extends Equatable {
  const SinglePostState();
}

final class SinglePostInitial extends SinglePostState {
  @override
  List<Object> get props => [];
}

class GetSinglePostLoading extends SinglePostState {
  @override
  List<Object> get props => [];
}


class GetSinglePostLoaded extends SinglePostState {
  final PostEntity post;

  GetSinglePostLoaded({required this.post});
  @override
  List<Object> get props => [post];
}

class GetSinglePostFailure extends SinglePostState {
  @override
  List<Object> get props => [];
}
