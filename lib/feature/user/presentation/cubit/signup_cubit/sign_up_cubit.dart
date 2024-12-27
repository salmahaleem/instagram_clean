
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/domain/usecase/signup_usecase.dart';

import 'package:meta/meta.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
   SignupUseCase signupUseCase;

  SignUpCubit({required this.signupUseCase,})
      : super(SignUpInitial());


  Future<void> signup({required UserEntity user}) async {
   final UserEntity user = UserEntity(
    email: Constant.email.text,
    password: Constant.password.text,
    bio: Constant.bio.text,
    username: Constant.username.text,
    phone: Constant.phone.text,
    gender: Constant.gender.text,
   );

   //  if (user.email.isEmpty || user.password.isEmpty) {
   //    emit(SignUpFailed("Email and password cannot be empty."));
   //    return;
   //  }
   //
   //  if (username.isEmpty || gender.isEmpty || phone.isEmpty) {
   //    emit(SignUpFailed("All fields are required."));
   //    return;
   //  }
   //  // final UserEntity user = UserEntity(
   //  //   profileUrl: profileUrl ?? "",
   //  //   email: email,
   //  //   password: password,
   //  //   username: username,
   //  //   gender: gender,
   //  //   phone: phone,
   //  // );
   //
    if (user.email!.isEmpty || user.password!.isEmpty) {
      emit(SignUpFailed("Email and password cannot be empty"));
      return;
    }

   if (user.username!.isEmpty || user.phone!.isEmpty || user.gender!.isEmpty) {
     emit(SignUpFailed("Email and password cannot be empty"));
     return;
   }
    emit(SignUpLoading());
    try {
      await signupUseCase.call(user);
      emit(SignUpSuccess(user));
    } catch (error) {
      emit(SignUpFailed("$error is error"));
    }
  }
}

@override
void close() {
  Constant.email.dispose();
  Constant.password.dispose();
  Constant.username.dispose();
  Constant.phone.dispose();
  Constant.gender.dispose();
  return close();
}