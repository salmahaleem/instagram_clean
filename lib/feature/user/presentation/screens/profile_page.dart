import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/presentation/widgets/profile_widgets/profile_info1.dart';
import 'package:instagram_clean/feature/user/presentation/widgets/profile_widgets/profile_info2.dart';
import 'package:instagram_clean/feature/user/presentation/widgets/profile_widgets/profile_tabcontroller.dart';
import 'package:instagram_clean/feature/user/presentation/widgets/profile_widgets/settings_menu.dart';
import 'package:sidebarx/sidebarx.dart';

class ProfilePage extends StatelessWidget {
  final UserEntity currentUser;

   ProfilePage({Key? key, required this.currentUser}) : super(key: key);

  final _key = GlobalKey<ScaffoldState>();

  // @override
  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return Center(child: Text("No user data available"));
    }
    return Scaffold(
      key: _key,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar:
          AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text(currentUser.username.toString()),
              actions: [
                Icon(Icons.add_box_outlined),
                horizontalSpace(5.w),
                IconButton(
                  onPressed: () {
                    context.go('/settings');
                  },
                  icon: Icon(Icons.menu),
                ),
              ],
            ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ProfileInfo1(
              userEntity: currentUser,
            ),
            verticalSpace(10.h),
            ProfileInfo2(
              userEntity: currentUser,
            ),
            verticalSpace(10.h),
            ProfileTabController(),
          ],
        ),
      ),
    );
  }
}
