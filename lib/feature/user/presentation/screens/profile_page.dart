import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/profile_cubit/get_single_user_cubit/get_single_user_cubit.dart';
import 'package:instagram_clean/feature/user/presentation/widgets/profile_widgets/profile_info1.dart';
import 'package:instagram_clean/feature/user/presentation/widgets/profile_widgets/profile_info2.dart';
import 'package:instagram_clean/feature/user/presentation/widgets/profile_widgets/profile_tabcontroller.dart';

class ProfilePage extends StatelessWidget {
  final UserEntity userEntity;

  ProfilePage({Key? key, required this.userEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
      builder: (context, state) {
        if(state is GetSingleUserLoading){
          return Center(child: CircularProgressIndicator());

        }
        if(state is GetSingleUserLoaded){
          final currentUser = state.user;
          return Scaffold(
            backgroundColor: Theme
                .of(context)
                .scaffoldBackgroundColor,
            appBar:
            AppBar(
              backgroundColor: Theme
                  .of(context)
                  .scaffoldBackgroundColor,
              title: Text("${currentUser.username}"),
              leading: GestureDetector(onTap:()
                  {context.go('/mainPage/:${state.user.uid}',);},
                child: Icon(Icons.arrow_back),
              ),
              actions: [
                Icon(Icons.add_box_outlined),
                horizontalSpace(5.w),
                IconButton(
                  onPressed: () {
                    context.go('/settings',extra: currentUser);
                  },
                  icon: Icon(Icons.menu),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ProfileInfo1(userEntity: currentUser,),
                    verticalSpace(10.h),
                    ProfileInfo2(
                      userEntity: currentUser,
                    ),
                    verticalSpace(10.h),
                    ProfileTabController(userEntity: currentUser),
                  ],
                ),
              ),
            ),
          );
        }
        return Center(child:Text("No user found"));
      },
    );
  }
}
