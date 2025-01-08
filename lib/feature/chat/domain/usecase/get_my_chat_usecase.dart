import 'package:instagram_clean/feature/chat/domain/entity/chat_entity.dart';
import 'package:instagram_clean/feature/chat/domain/repository/chat_firebase_repo.dart';

class GetMyChatUseCase {

  final ChatFirebaseRepo chatFirebaseRepo;

  GetMyChatUseCase({required this.chatFirebaseRepo});

  Stream<List<ChatEntity>> call(ChatEntity chat)  {
    return chatFirebaseRepo.getMyChat(chat);
  }
}