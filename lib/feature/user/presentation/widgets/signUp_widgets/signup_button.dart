import 'dart:io';

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/core/widgets/instagramButton.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/signup_cubit/sign_up_cubit.dart';
import 'package:instagram_clean/generated/locale_keys.dart';

class SignupButton extends StatefulWidget {
  final UserEntity userEntity;

  SignupButton({required this.userEntity});

  @override
  State<SignupButton> createState() => _SignupButtonState();
}

class _SignupButtonState extends State<SignupButton> {

  bool _isSigningUp = false;
  bool _isUploading = false;

  //File? _image;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocConsumer<SignUpCubit, SignUpState>(
          listener: (context, state) {
            if (state is SignUpSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("SignUp Successful!"),
                  backgroundColor: Color(0xFFA5D6A7),
                ),
              );
              context.go('/mainPage/:${state.user.uid}');
            } else if (state is SignUpFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.error),
                    backgroundColor: Color(0xFFEF5350)),
              );
            }
          },
          builder: (context, state) {
            if (state is SignUpLoading) {
              return Center(child: CircularProgressIndicator());
            }else if (state is SignUpSuccess){
              return InstagramButton(
                  text: "${LocaleKeys.authenticationRegister.tr()}",
                  onPressed: () {
                    _signUpUser();
                  });
          }
            return InstagramButton(
                text: "${LocaleKeys.authenticationRegister.tr()}",
                onPressed: () {
                  _signUpUser();
                });
          }
        ),
        verticalSpace(8.h),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: LocaleKeys.authenticationalready_have_account.tr(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextSpan(
                text: '  ${LocaleKeys.authenticationLogin.tr()}',
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(fontSize: 13.sp),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    context.go('/');
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _signUpUser() async {
    setState(() {
      _isSigningUp = true;
    });
    BlocProvider.of<SignUpCubit>(context).signup(
        user: UserEntity(
            email: Constant.email.text,
            password: Constant.password.text,
            bio: "",
            username: Constant.username.text,
            totalPosts: 0,
            totalFollowing: 0,
            followers: [],
            totalFollowers: 0,
            website: "",
            following: [],
            profileUrl:Constant.profileUrl ,
            phone: Constant.phone.text,
            gender: Constant.gender.text,
            imageFile: Constant.profileImage,
            //profileUrl: userEntity.profileUrl
        )
    ).then((value) => _clear());
  }

  _clear() {
    setState(() {
      Constant.username.clear();
      Constant.phone.clear();
      Constant.gender.clear();
      Constant.email.clear();
      Constant.password.clear();
      _isSigningUp = false;
    });
  }

}
