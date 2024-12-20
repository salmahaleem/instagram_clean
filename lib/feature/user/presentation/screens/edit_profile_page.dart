import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clean/core/utils/colors.dart';
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/core/widgets/userPhoto.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:instagram_clean/feature/user/presentation/widgets/edit_profile_widgets/main_info.dart';
import 'package:instagram_clean/feature/user/presentation/widgets/edit_profile_widgets/private_info.dart';
import 'package:instagram_clean/generated/locale_keys.dart';

class EditProfilePage extends StatefulWidget {
  final UserEntity? userEntity;

  const EditProfilePage({this.userEntity});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}
class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(
          width: 100.w,
          child: TextButton(onPressed: () {
            context.go('/profile');
          }, child: Text('${LocaleKeys.profile_cancel.tr()}',style: Theme.of(context).textTheme.titleSmall),),
        ),
        title: Center(child: Text('${LocaleKeys.profile_editProfile.tr()}',style: TextStyle(fontSize: 15.sp),)),
        actions: [
          TextButton(
            onPressed: () {
            _updateUserProfile;
          }, child: Text('${LocaleKeys.profile_done.tr()}',style: TextStyle(fontSize: 15.sp,color: AppColors.buttonColor),),),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              UserPhoto(),
              verticalSpace(30.h),
              MainInfo(),
              verticalSpace(40.h),
              Align(alignment: AlignmentDirectional.topStart,
                  child: Text('${LocaleKeys.profile_private_information.tr()}',style: Theme.of(context).textTheme.titleLarge,)),
              verticalSpace(20.h),
              PrivateInfo()
            ],
          ),
        ),
      ),
    );
  }

  _updateUserProfile(String profileUrl) {
    BlocProvider.of<ProfileCubit>(context).updateUser(
        user: UserEntity(
            uid: widget.userEntity!.uid,
            username: Constant.username.text,
            bio: Constant.bio.text,
            website: Constant.website.text,
            email: Constant.email.text,
            phone: Constant.phone.text,
            gender: Constant.gender.text,
            profileUrl: profileUrl
        )
    ).then((value) => _clear());
    SnackBar(
      content: Text("Updated Successful!"),
      backgroundColor: Color(0xFFA5D6A7),
    );
  }
  _clear() {
    setState(() {
      //_isUpdating = false;
      Constant.username.clear();
      Constant.bio.clear();
      Constant.website.clear();
      Constant.email.clear();
      Constant.phone.clear();
      Constant.gender.clear();
    });
    Navigator.pop(context);
  }
}