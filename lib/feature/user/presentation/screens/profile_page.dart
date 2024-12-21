import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/profile_cubit/get_single_user_cubit/get_single_user_cubit.dart';
import 'package:instagram_clean/feature/user/presentation/widgets/profile_widgets/profile_info1.dart';
import 'package:instagram_clean/feature/user/presentation/widgets/profile_widgets/profile_info2.dart';
import 'package:instagram_clean/feature/user/presentation/widgets/profile_widgets/profile_tabcontroller.dart';
import 'package:instagram_clean/feature/user/presentation/widgets/profile_widgets/settings_menu.dart';
import 'package:sidebarx/sidebarx.dart';

class ProfilePage extends StatelessWidget {
  final UserEntity currentUser;

   ProfilePage({Key? key, required this.currentUser}) : super(key: key);

  final SidebarXController drawerCont =
      SidebarXController(selectedIndex: 0, extended: false);

  final _key = GlobalKey<ScaffoldState>();

  // @override
  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      key: _key,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: isSmallScreen
          ? AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text('${currentUser.username}'),
              actions: [
                Icon(Icons.add_box_outlined),
                horizontalSpace(5.w),
                IconButton(
                  onPressed: () {
                    _key.currentState?.openDrawer();
                  },
                  icon: Icon(Icons.menu),
                ),
              ],
            )
          : null,
      drawer: SettingsMenu(sideController: drawerCont),
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
            ProfileTabController()
          ],
        ),
      ),
    );
  }
}
