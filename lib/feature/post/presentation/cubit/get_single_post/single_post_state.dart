part of 'single_post_cubit.dart';

abstract class SinglePostState extends Equatable {
  const SinglePostState();
}

final class SinglePostInitial extends SinglePostState {
  @override
  List<Object> get props => [];
}

class SinglePostLoading extends SinglePostState {
  @override
  List<Object> get props => [];
}


class SinglePostLoaded extends SinglePostState {
  final PostEntity post;

  SinglePostLoaded({required this.post});
  @override
  List<Object> get props => [post];
}

class SinglePostFailure extends SinglePostState {
  @override
  List<Object> get props => [];
}
