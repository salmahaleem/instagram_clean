import 'package:instagram_clean/feature/chat/domain/entity/chat_entity.dart';
import 'package:instagram_clean/feature/chat/domain/entity/message_entity.dart';
import 'package:instagram_clean/feature/chat/domain/repository/chat_firebase_repo.dart';

class SendMessageUseCase {

  final ChatFirebaseRepo chatFirebaseRepo;

  SendMessageUseCase({required this.chatFirebaseRepo});

  Future<void> call(ChatEntity chat, MessageEntity message) async {
    return await chatFirebaseRepo.sendMessage(chat, message);
  }
}