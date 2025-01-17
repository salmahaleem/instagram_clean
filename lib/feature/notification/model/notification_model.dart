import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel{
  final String? notificationId;
  final String? uid;
  final String? otherUid;
  final String? username;
  final String? description;
  final Timestamp? createdAt;
  final String? userProfile;

  NotificationModel(
      {this.notificationId,
      this.uid,
      this.otherUid,
      this.username,
      this.description,
      this.createdAt,
      this.userProfile});


  factory NotificationModel.fromSnapshot(DocumentSnapshot snapshot) {
    final snap = snapshot.data() as Map<String, dynamic>;

    return NotificationModel(
        notificationId: snap['notificationId'],
        username: snap['username'],
        createdAt: snap['createdAt'],
        uid: snap['uid'],
        userProfile: snap['userProfile'],
        description: snap['description']
    );
  }

  Map<String, dynamic> toDocument() => {
    "storyId": notificationId,
    "username": username,
    "createdAt": createdAt,
    "uid": uid,
    "profileUrl": userProfile,
    "description": description,
  };

}