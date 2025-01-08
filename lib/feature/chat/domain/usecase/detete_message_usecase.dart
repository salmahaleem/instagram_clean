
import 'package:instagram_clean/feature/chat/domain/entity/message_entity.dart';
import 'package:instagram_clean/feature/chat/domain/repository/chat_firebase_repo.dart';

class DeleteMessageUseCase {

  final ChatFirebaseRepo chatFirebaseRepo;

  DeleteMessageUseCase({required this.chatFirebaseRepo});

  Future<void> call(MessageEntity message) async {
    return await chatFirebaseRepo.deleteMessage(message);
  }
}