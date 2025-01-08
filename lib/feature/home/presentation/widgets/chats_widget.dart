import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clean/core/get_it/get_it.dart'as di;
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/core/widgets/userPhoto.dart';
import 'package:instagram_clean/feature/chat/domain/entity/message_entity.dart';
import 'package:instagram_clean/feature/chat/presentation/screens/chats_page.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/domain/usecase/getCurrentUserId_usecase.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/profile_cubit/get_single_user_cubit/get_single_user_cubit.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/profile_cubit/profile_cubit.dart';

class ChatsWidget extends StatefulWidget {
  final String uid;
  final UserEntity userEntity;

  const ChatsWidget({super.key, required this.uid, required this.userEntity});
  @override
  State<ChatsWidget> createState() => _ChatsWidgetState();
}

class _ChatsWidgetState extends State<ChatsWidget> {
  TextEditingController _searchController = TextEditingController();
  String _currentUid = "";


  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileCubit>(context).getAllUsers(user: UserEntity());
    BlocProvider.of<GetSingleUserCubit>(context).getSingleUser(uid: widget.uid);
    di.getIt<GetCurrentUserIdUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => ChatsPage(uid: widget.uid)))},
          child: Icon(Icons.arrow_back),
        ),
        title: Text(
          "Chat",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body:BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, userState) {
              if (userState is ProfileLoaded) {
                final contacts = userState.users
                    .where((user) => user.uid != _currentUid)
                    .toList();
                if (contacts.isEmpty) {
                  return Center(
                    child: Text("No Contacts Yet"),
                  );
                }
                return ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final contact = contacts[index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 5.0, left: 10.0),
                        child: Container(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: ()=> context.go('/singleChatPage',extra: MessageEntity(
                                    senderUid: Constant.userEntity.uid,
                                    recipientUid:contact.uid,
                                    senderName: Constant.userEntity.username,
                                    recipientName: contact.username,
                                    senderProfile: Constant.userEntity.profileUrl,
                                    recipientProfile: contact.profileUrl,
                                    uid: widget.uid
                                )),
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  width: 40,
                                  height: 40,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: UserPhoto(
                                          imageUrl: contact.profileUrl,
                                          image: contact.imageFile)),
                                ),
                              ),
                              horizontalSpace(10.w),
                              Text("${contact.username}"),
                            ],
                          ),
                        ),
                      );
                    });
              }
              return Center(
                child: Text("No user"),
              );
            },
          )

    );
  }
}
