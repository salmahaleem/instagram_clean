import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clean/feature/story/domain/entity/story_entity.dart';
import 'package:instagram_clean/feature/story/domain/usecase/get_my_story.dart';

part 'my_story_state.dart';

class MyStoryCubit extends Cubit<MyStoryState> {
  final GetMyStoryUseCase getMyStoryUseCase;
  MyStoryCubit({required this.getMyStoryUseCase}) : super(MyStoryInitial());

  Future<void> getMyStory({required String uid}) async {
    try {

      emit(MyStoryLoading());
      final streamResponse = getMyStoryUseCase.call(uid);
      streamResponse.listen((stories) {
        print("MyStories = $stories");
        if(stories.isEmpty) {
          emit(const MyStoryLoaded(myStory: null));
        } else {
          emit(MyStoryLoaded(myStory: stories.first));
        }
      });

    } on SocketException {
      emit(MyStoryFailure());
    } catch(_) {
      emit(MyStoryFailure());
    }
  }
}

