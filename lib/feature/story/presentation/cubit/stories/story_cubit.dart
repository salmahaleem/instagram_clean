import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clean/feature/story/domain/entity/story_entity.dart';
import 'package:instagram_clean/feature/story/domain/usecase/create_story_usecase.dart';
import 'package:instagram_clean/feature/story/domain/usecase/delete_story_usecase.dart';
import 'package:instagram_clean/feature/story/domain/usecase/get_story_usecase.dart';
import 'package:instagram_clean/feature/story/domain/usecase/seen_story_update.dart';
import 'package:instagram_clean/feature/story/domain/usecase/update_only_image_story.dart';
import 'package:instagram_clean/feature/story/domain/usecase/update_story.dart';

part 'story_state.dart';

class StoryCubit extends Cubit<StoryState> {
  final CreateStoryUseCase createStoryUseCase;
  final DeleteStoryUseCase deleteStoryUseCase;
  final UpdateStoryUseCase updateStoryUseCase;
  final GetStoryUseCase getStoryUseCase;
  final UpdateOnlyImageStoryUseCase updateOnlyImageStoryUseCase;
  final SeenStoryUpdateUseCase seenStoryUpdateUseCase;
  StoryCubit(
      {required this.createStoryUseCase,
        required this.deleteStoryUseCase,
        required this.updateStoryUseCase,
        required this.getStoryUseCase,
        required this.updateOnlyImageStoryUseCase,
        required this.seenStoryUpdateUseCase
      }) : super(StoryInitial());

  Future<void> createStory({required StoryEntity story}) async {

    try {
      await createStoryUseCase.call(story);

    } on SocketException {
      emit(StoryFailure());
    } catch(_) {
      emit(StoryFailure());
    }
  }

  Future<void> getStory({required StoryEntity story}) async {
    try {

      emit(StoryLoading());
      final streamResponse = getStoryUseCase.call(story);
      streamResponse.listen((stories) {
        print("stories = $stories");
        emit(StoryLoaded(Storys:stories));
      });

    } on SocketException {
      emit(StoryFailure());
    } catch(_) {
      emit(StoryFailure());
    }
  }


  Future<void> deleteStory({required StoryEntity story}) async {

    try {
      await deleteStoryUseCase.call(story);

    } on SocketException {
      emit(StoryFailure());
    } catch(_) {
      emit(StoryFailure());
    }
  }

  Future<void> updateStory({required StoryEntity story}) async {

    try {
      await updateStoryUseCase.call(story);

    } on SocketException {
      emit(StoryFailure());
    } catch(_) {
      emit(StoryFailure());
    }
  }

  Future<void> updateOnlyImageStory({required StoryEntity story}) async {

    try {
      await updateOnlyImageStoryUseCase.call(story);

    } on SocketException {
      emit(StoryFailure());
    } catch(_) {
      emit(StoryFailure());
    }
  }

  Future<void> seenStoryUpdate({required String storyId, required int imageIndex, required String userId}) async {

    try {
      await seenStoryUpdateUseCase.call(storyId, imageIndex, userId);

    } on SocketException {
      emit(StoryFailure());
    } catch(_) {
      emit(StoryFailure());
    }
  }
}

