part of 'story_cubit.dart';

sealed class StoryState extends Equatable {
  const StoryState();
}

final class StoryInitial extends StoryState {
  @override
  List<Object> get props => [];
}

class StoryLoading extends StoryState {
  @override
  List<Object> get props => [];
}

class StoryLoaded extends StoryState {
  final List<StoryEntity> Storys;

  StoryLoaded({required this.Storys});
  @override
  List<Object> get props => [Storys];
}

class StoryFailure extends StoryState {
  @override
  List<Object> get props => [];
}