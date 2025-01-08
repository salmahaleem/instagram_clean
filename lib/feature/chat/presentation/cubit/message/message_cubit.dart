import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clean/feature/chat/domain/entity/chat_entity.dart';
import 'package:instagram_clean/feature/chat/domain/entity/message_entity.dart';
import 'package:instagram_clean/feature/chat/domain/entity/message_replay_entity.dart';
import 'package:instagram_clean/feature/chat/domain/usecase/detete_message_usecase.dart';
import 'package:instagram_clean/feature/chat/domain/usecase/get_message_usecase.dart';
import 'package:instagram_clean/feature/chat/domain/usecase/seen_message_update_usecase.dart';
import 'package:instagram_clean/feature/chat/domain/usecase/send_message_usecase.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final DeleteMessageUseCase deleteMessageUseCase;
  final SeenMessageUpdateUseCase seenMessageUpdateUseCase;
  MessageCubit(
      {required this.getMessagesUseCase,
      required this.sendMessageUseCase,
      required this.deleteMessageUseCase,
      required this.seenMessageUpdateUseCase}) : super(MessageInitial());


  Future<void> getMessages({required MessageEntity message}) async {
    try {
      emit(MessageLoading());

      final streamResponse = getMessagesUseCase.call(message);
      streamResponse.listen((messages) {
        emit(MessageLoaded(messages: messages));
      });

    } on SocketException {
      emit(MessageFailure());
    } catch (_) {
      emit(MessageFailure());
    }
  }

  Future<void> sendMessage({required ChatEntity chat, required MessageEntity message}) async {
    try {

      await sendMessageUseCase.call(chat, message);

    } on SocketException {
      emit(MessageFailure());
    } catch (_) {
      emit(MessageFailure());
    }
  }

  Future<void> seenMessage({required MessageEntity message}) async {
    try {

      await seenMessageUpdateUseCase.call(message);

    } on SocketException {
      emit(MessageFailure());
    } catch (_) {
      emit(MessageFailure());
    }
  }

  MessageReplayEntity messageReplay = MessageReplayEntity();

  MessageReplayEntity get getMessageReplay => MessageReplayEntity();

  set setMessageReplay(MessageReplayEntity messageReplay) {
    this.messageReplay = messageReplay;
  }

  Future<void> deleteMessage({required MessageEntity message}) async {
    try {

      await deleteMessageUseCase.call(message);

    } on SocketException {
      emit(MessageFailure());
    } catch (_) {
      emit(MessageFailure());
    }
  }
}
