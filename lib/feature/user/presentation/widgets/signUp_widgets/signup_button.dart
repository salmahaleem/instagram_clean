import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/core/widgets/instagramButton.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/signup_cubit/sign_up_cubit.dart';
import 'package:instagram_clean/generated/locale_keys.dart';

class SignupButton extends StatelessWidget {
  final UserEntity? userEntity;

  SignupButton({this.userEntity});
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
              context.go('/mainPage');
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
            }
            return InstagramButton(
                text: "${LocaleKeys.authenticationRegister.tr()}",
                onPressed: () {
                  context.read<SignUpCubit>().signup();
                });
          },
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
}
