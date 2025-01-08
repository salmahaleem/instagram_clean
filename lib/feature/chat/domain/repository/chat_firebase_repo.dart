import 'package:instagram_clean/feature/chat/domain/entity/chat_entity.dart';
import 'package:instagram_clean/feature/chat/domain/entity/message_entity.dart';

abstract class ChatFirebaseRepo {

  Future<void> sendMessage(ChatEntity chat, MessageEntity message);
  Stream<List<ChatEntity>> getMyChat(ChatEntity chat);
  Stream<List<MessageEntity>> getMessages(MessageEntity message);
  Future<void> deleteMessage(MessageEntity message);
  Future<void> seenMessageUpdate(MessageEntity message);

  Future<void> deleteChat(ChatEntity chat);
}