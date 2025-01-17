import 'package:firebase_messaging/firebase_messaging.dart';

class GetTokenUseCase{
  final FirebaseMessaging firebaseMessaging;

  GetTokenUseCase({required this.firebaseMessaging});

  Future<String?> call() async{
    return await firebaseMessaging.getToken();
  }

}