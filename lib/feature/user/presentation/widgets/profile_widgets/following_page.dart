import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clean/core/get_it/get_it.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/core/widgets/userPhoto.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/domain/usecase/getSingleUser_usecase.dart';
import 'package:instagram_clean/generated/locale_keys.dart';

class FollowingPage extends StatelessWidget {
  final UserEntity user;
  const FollowingPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("${LocaleKeys.profile_following.tr()}"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: user.following!.isEmpty? _noFollowersWidget() :  ListView.builder(itemCount: user.following!.length,itemBuilder: (context, index) {
                return StreamBuilder<List<UserEntity>>(
                    stream: getIt<GetSingleUserUseCase>().call(user.following![index]),
                    builder: (context, snapshot) {
                      if (snapshot.hasData == false) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.data!.isEmpty) {
                        return Container();
                      }
                      final singleUserData = snapshot.data!.first;
                      return GestureDetector(
                        onTap: () {
                          context.go('/singleUserPage/:${singleUserData.uid}');
                        },
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              width: 40,
                              height: 40,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: UserPhoto(imageUrl: singleUserData.profileUrl),
                              ),
                            ),
                            horizontalSpace(10.w),
                            Text("${singleUserData.username}", style: Theme.of(context).textTheme.titleSmall)
                          ],
                        ),
                      );
                    }
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  _noFollowersWidget() {
    return Center(
      child: Text("No Following", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),),
    );
  }
}