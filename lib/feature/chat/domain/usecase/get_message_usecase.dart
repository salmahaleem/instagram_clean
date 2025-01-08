import 'package:instagram_clean/feature/chat/domain/entity/message_entity.dart';
import 'package:instagram_clean/feature/chat/domain/repository/chat_firebase_repo.dart';

class GetMessagesUseCase {

  final ChatFirebaseRepo chatFirebaseRepo;

  GetMessagesUseCase({required this.chatFirebaseRepo});

  Stream<List<MessageEntity>> call(MessageEntity message)  {
    return chatFirebaseRepo.getMessages(message);
  }
}