// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:instagram_clean/feature/story/domain/entity/story_entity.dart';
// import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
//
// bodyWidget(List<StoryEntity> story, UserEntity currentUser, {StoryEntity? myStorys}) {
//   final UserEntity currentUser;
//   return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Stack(
//                   children: [
//                     myStorys != null
//                         ? GestureDetector(
//                       onTap: () {
//                         _eitherShowOrUploadSheet(myStorys, currentUser);
//                       },
//                       child: Container(
//                         width: 55,
//                         height: 55,
//                         margin: const EdgeInsets.all(12.5),
//                         child: CustomPaint(
//                           painter: StatusDottedBordersWidget(
//                               isMe: true,
//                               numberOfStories: myStorys.stories!.length,
//                               spaceLength: 4,
//                               images: myStorys.stories!,
//                               uid: widget.currentUser.uid
//                           ),
//                           child: Container(
//                             margin: const EdgeInsets.all(3),
//                             width: 55,
//                             height: 55,
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(30),
//                               child: profileWidget(imageUrl: myStatus.imageUrl),
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                         : Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                       width: 60,
//                       height: 60,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(30),
//                         child: profileWidget(imageUrl: currentUser.profileUrl),
//                       ),
//                     ),
//
//
//                     myStatus != null
//                         ? Container()
//                         : Positioned(
//                       right: 10,
//                       bottom: 8,
//                       child: GestureDetector(
//                         onTap: () {
//                           _eitherShowOrUploadSheet(myStatus, currentUser);
//                         },
//                         child: Container(
//                           width: 25,
//                           height: 25,
//                           decoration: BoxDecoration(
//                               color: tabColor,
//                               borderRadius: BorderRadius.circular(25),
//                               border: Border.all(width: 2, color: backgroundColor)),
//                           child: const Center(
//                             child: Icon(
//                               Icons.add,
//                               size: 20,
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//                 Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           "My status",
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         const SizedBox(
//                           height: 2,
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             _eitherShowOrUploadSheet(myStatus, currentUser);
//
//                           },
//                           child: const Text(
//                             "Tap to add your status update",
//                             style: TextStyle(color: greyColor),
//                           ),
//                         )
//                       ],
//                     )),
//
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pushNamed(context, PageConst.myStatusPage, arguments: myStatus);
//                   },
//                   child: Icon(
//                     Icons.more_horiz,
//                     color: greyColor.withOpacity(.5),
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             const Padding(
//               padding: EdgeInsets.only(left: 10.0),
//               child: Text(
//                 "Recent updates",
//                 style: TextStyle(
//                     fontSize: 15, color: greyColor, fontWeight: FontWeight.w500),
//               ),
//             ),
//
//             const SizedBox(height: 10,),
//
//             ListView.builder(
//                 itemCount: statuses.length,
//                 shrinkWrap: true,
//                 physics: const ScrollPhysics(),
//                 itemBuilder: (context, index) {
//
//                   final status = statuses[index];
//
//                   List<StoryItem> stories = [];
//
//                   for (StatusImageEntity storyItem in status.stories!) {
//                     stories.add(StoryItem(url: storyItem.url!,
//                         viewers: storyItem.viewers,
//                         type: StoryItemTypeExtension.fromString(storyItem.type!)));
//                   }
//
//
//                   return ListTile(
//                     onTap: () {
//                       _showStatusImageViewBottomModalSheet(status: status, stories: stories);
//                     },
//                     leading: SizedBox(
//                       width: 55,
//                       height: 55,
//                       child: CustomPaint(
//                         painter: StatusDottedBordersWidget(
//                             isMe: false,
//                             numberOfStories: status.stories!.length,
//                             spaceLength: 4,
//                             images: status.stories,
//                             uid: widget.currentUser.uid
//                         ),
//                         child: Container(
//                           margin: const EdgeInsets.all(3),
//                           width: 55,
//                           height: 55,
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(30),
//                             child: profileWidget(imageUrl: status.imageUrl),
//                           ),
//                         ),
//                       ),
//                     ),
//                     title: Text(
//                       "${status.username}",
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     subtitle: Text(formatDateTime(status.createdAt!.toDate())),
//                   );
//                 })
//           ],
//         ),
//       ));
// }