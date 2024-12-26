import 'dart:io';

import 'package:instagram_clean/feature/user/domain/repository/user_firebase_repo.dart';

class UploadImageToStorageUseCase {
  final UserFirebaseRepo userFirebaseRepo;

  UploadImageToStorageUseCase({required this.userFirebaseRepo});

  Future<String> call(File file, bool isPost, String childName) {
    return userFirebaseRepo.uploadImageToStorage(file, isPost, childName);
  }
}