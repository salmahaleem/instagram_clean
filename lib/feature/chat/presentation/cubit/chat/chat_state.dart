part of 'chat_cubit.dart';

sealed class ChatState extends Equatable {
  const ChatState();
}

final class ChatInitial extends ChatState {
  @override
  List<Object> get props => [];
}

class ChatLoading extends ChatState {
  @override
  List<Object> get props => [];
}


class ChatLoaded extends ChatState {
  final List<ChatEntity> chats;

  const ChatLoaded({required this.chats});
  @override
  List<Object> get props => [chats];
}


class ChatFailure extends ChatState {
  @override
  List<Object> get props => [];
}