import 'package:instagram_clean/feature/chat/domain/entity/chat_entity.dart';
import 'package:instagram_clean/feature/chat/domain/entity/message_entity.dart';
import 'package:instagram_clean/feature/chat/domain/repository/chat_firebase_repo.dart';

class ChatFirebaseRepoImpl implements ChatFirebaseRepo{
  final ChatFirebaseRepo chatFirebaseRepo;

  ChatFirebaseRepoImpl({required this.chatFirebaseRepo});

  @override
  Future<void> deleteChat(ChatEntity chat) async => chatFirebaseRepo.deleteChat(chat);

  @override
  Future<void> deleteMessage(MessageEntity message) async => chatFirebaseRepo.deleteMessage(message);

  @override
  Stream<List<MessageEntity>> getMessages(MessageEntity message) => chatFirebaseRepo.getMessages(message);

  @override
  Stream<List<ChatEntity>> getMyChat(ChatEntity chat) => chatFirebaseRepo.getMyChat(chat);

  @override
  Future<void> sendMessage(ChatEntity chat, MessageEntity message) async => chatFirebaseRepo.sendMessage(chat, message);

  @override
  Future<void> seenMessageUpdate(MessageEntity message) async => chatFirebaseRepo.seenMessageUpdate(message);
  
}