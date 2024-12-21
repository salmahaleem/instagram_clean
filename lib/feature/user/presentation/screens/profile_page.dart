import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/profile_cubit/get_single_user_cubit/get_single_user_cubit.dart';
import 'package:instagram_clean/feature/user/presentation/widgets/profile_widgets/profile_info1.dart';
import 'package:instagram_clean/feature/user/presentation/widgets/profile_widgets/profile_info2.dart';
import 'package:instagram_clean/feature/user/presentation/widgets/profile_widgets/profile_tabcontroller.dart';
import 'package:instagram_clean/feature/user/presentation/widgets/profile_widgets/settings_menu.dart';
import 'package:sidebarx/sidebarx.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final SidebarXController drawerCont =
      SidebarXController(selectedIndex: 0, extended: false);
  final _key = GlobalKey<ScaffoldState>();

  // @override
  // void initState() {
  //   BlocProvider.of<GetSingleUserCubit>(context).getSingleUser(uid: widget.uid);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
      builder: (context, state) {
        if (state is GetSingleUserLoaded) {
          final currentUser = state.user;
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
       else if (state is GetSingleUserFailed) {
          return Center(child: Text('Failed to load profile'));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
