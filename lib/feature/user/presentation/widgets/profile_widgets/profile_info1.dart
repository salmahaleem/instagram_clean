import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clean/core/get_it/get_it.dart' as di;
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/core/widgets/userPhoto.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/domain/usecase/getCurrentUserId_usecase.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/profile_cubit/get_other_single_user/get_other_single_user_cubit.dart';
import 'package:instagram_clean/generated/locale_keys.dart';

class ProfileInfo1 extends StatefulWidget {
  final UserEntity userEntity;

  const ProfileInfo1({super.key, required this.userEntity,});

  @override
  State<ProfileInfo1> createState() => _ProfileInfo1State();
}

class _ProfileInfo1State extends State<ProfileInfo1> {

  @override
  Widget build(BuildContext context) {
          return Row(
            children: [
              Container(
                width: 100,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: UserPhoto(imageUrl:widget.userEntity.profileUrl,
                      image: widget.userEntity.imageFile),
                ),
              ),
              horizontalSpace(40.w),
              Column(
                children: [
                  Text('${widget.userEntity.totalPosts}'),
                  verticalSpace(2.h),
                  Text('${LocaleKeys.profile_posts.tr()}'),
                ],
              ),
              horizontalSpace(13.w),
              Column(
                children: [
                  Text('${widget.userEntity.totalFollowers}'),
                  verticalSpace(2.h),
                  Text('${LocaleKeys.profile_followers.tr()}'),
                ],
              ),
              horizontalSpace(13.w),
              Column(
                children: [
                  Text("${widget.userEntity.totalFollowing}"),
                  verticalSpace(2.h),
                  Text('${LocaleKeys.profile_following.tr()}'),
                ],
              ),
            ],
          );
  }
}