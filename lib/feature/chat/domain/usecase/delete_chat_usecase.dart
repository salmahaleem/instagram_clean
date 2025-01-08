import 'package:instagram_clean/feature/chat/domain/entity/chat_entity.dart';
import 'package:instagram_clean/feature/chat/domain/repository/chat_firebase_repo.dart';

class DeleteChatUseCase {

  final ChatFirebaseRepo chatFirebaseRepo ;

  DeleteChatUseCase({required this.chatFirebaseRepo});

  Future<void> call(ChatEntity chat) async {
    return await chatFirebaseRepo.deleteChat(chat);
  }
}