part of 'my_story_cubit.dart';

sealed class MyStoryState extends Equatable {
  const MyStoryState();
}

final class MyStoryInitial extends MyStoryState {
  @override
  List<Object> get props => [];
}

class MyStoryLoading extends MyStoryState {
  @override
  List<Object> get props => [];
}


class MyStoryLoaded extends MyStoryState {
  final StoryEntity? myStory;

  const MyStoryLoaded({this.myStory});
  @override
  List<Object?> get props => [myStory];
}


class MyStoryFailure extends MyStoryState {
  @override
  List<Object> get props => [];
}