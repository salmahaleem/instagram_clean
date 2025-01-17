import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/core/widgets/instagramButton.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/generated/locale_keys.dart';

class ProfileInfo2 extends StatelessWidget {
  final UserEntity userEntity;


  const ProfileInfo2({super.key, required this.userEntity});

  @override
  Widget build(BuildContext context) {
        return Column(
          children: [
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Column(
                children: [
                  Text('${userEntity.username}'),
                  Text('${userEntity.bio}'),
                ],
              ),
            ),
            verticalSpace(8.h),
            Row(
              children: [
                SizedBox(
                  width: 340.w,
                  height: 30.h,
                  child: Center(
                    child: InstagramButton(
                      text: '${LocaleKeys.profile_editProfile.tr()}',
                      onPressed: () {
                        context.go('/editProfile',extra: userEntity);
                      },),
                  ),
                ),
                // horizontalSpace(12.w),
                // SizedBox(
                //   width: 165.w,
                //   height: 30.h,
                //   child: InstagramButton(
                //     text: '${LocaleKeys.profile_follow.tr()}',
                //     onPressed: () {
                //
                //     },),
                // )
              ],
            ),


          ],
        );
      }
}