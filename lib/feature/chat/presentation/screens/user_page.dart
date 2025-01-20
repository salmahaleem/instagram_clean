import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clean/core/widgets/userPhoto.dart';
import 'package:instagram_clean/feature/chat/domain/entity/message_entity.dart';
import 'package:instagram_clean/feature/chat/presentation/screens/single_chat_page.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/profile_cubit/get_single_user_cubit/get_single_user_cubit.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:instagram_clean/generated/locale_keys.dart';

class ContactsPage extends StatefulWidget {
  final String uid;

  const ContactsPage({super.key, required this.uid});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {


  @override
  void initState() {
    BlocProvider.of<ProfileCubit>(context).getAllUsers(user: UserEntity());
    BlocProvider.of<GetSingleUserCubit>(context).getSingleUser(uid: widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("${LocaleKeys.chat_select_contacts.tr()}"),
      ),
      body: BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
        builder: (context, state) {
          if(state is GetSingleUserLoaded) {
            final currentUser = state.user;

            return BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoaded) {
                  final contacts = state.users.where((user) => user.uid != widget.uid).toList();
                  if (contacts.isEmpty) {
                    return  Center(
                      child: Text("${LocaleKeys.chat_no_contacts_yet.tr()}"),
                    );
                  }

                  return ListView.builder(itemCount: contacts.length, itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return ListTile(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SingleChatPage(message: MessageEntity(
                            senderUid: currentUser.uid,
                            recipientUid: contact.uid,
                            senderName: currentUser.username,
                            recipientName: contact.username,
                            senderProfile: currentUser.profileUrl,
                            recipientProfile: contact.profileUrl,
                            uid: widget.uid
                        ))));
                      },
                      leading: SizedBox(
                        width: 50,
                        height: 50,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: UserPhoto(imageUrl: contact.profileUrl)
                        ),
                      ),
                      title: Text("${contact.username}"),
                      
                    );
                  });
                }
                return const Center(
                  child: CircularProgressIndicator(
                   
                  ),
                );

              },

            );

          }
          return const Center(
            child: CircularProgressIndicator(

            ),
          );
        },
      ),
    );
  }
}

