import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/core/widgets/userPhoto.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/generated/locale_keys.dart';

class ProfileInfo1 extends StatelessWidget{
  final UserEntity userEntity;

  const ProfileInfo1({super.key,required this.userEntity});
  @override
  Widget build(BuildContext context) {
   return Row(
    children: [
      UserPhoto(),
      horizontalSpace(10.w),
      Column(
        children: [
          Text('${userEntity.totalPosts}'),
          verticalSpace(2.h),
          Text('${LocaleKeys.profile_posts.tr()}'),
        ],
      ),
      horizontalSpace(7.w),
      Column(
        children: [
          Text('${userEntity.totalFollowers}'),
          verticalSpace(2.h),
          Text('${LocaleKeys.profile_followers.tr()}'),
        ],
      ),
      horizontalSpace(7.w),
      Column(
        children: [
          Text('${userEntity.totalFollowing}'),
          verticalSpace(2.h),
          Text('${LocaleKeys.profile_following.tr()}'),
        ],
      ),
    ],
   );
  }

}