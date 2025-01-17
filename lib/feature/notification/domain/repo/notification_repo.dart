import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clean/feature/notification/model/notification_model.dart';

import '../../../../core/utils/constant.dart';

class NotificationRepo{
  final FirebaseFirestore firestore;

  NotificationRepo({required this.firestore});

  Future<void>generateNotification(NotificationModel notificationModel)async{

    final notificationCollection = firestore.collection(Constant.users)
                                            .doc(notificationModel.otherUid)
                                             .collection(Constant.notification);

    final String notificationId = notificationCollection.doc().id;

    final notificationData = NotificationModel(
      notificationId: notificationId,
      uid: notificationModel.uid,
      username: notificationModel.username,
      createdAt: Timestamp.now(),
      description: notificationModel.description,
      otherUid: notificationModel.otherUid,
      userProfile: notificationModel.userProfile
    ).toDocument();

   try{
     await notificationCollection.doc(notificationId).set(notificationData);
   }catch(e){
     print("error on notification generated");
   }
  }

}