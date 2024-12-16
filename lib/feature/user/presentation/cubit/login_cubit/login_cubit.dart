import 'package:bloc/bloc.dart';
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/domain/usecase/getCurrentUserId_usecase.dart';
import 'package:instagram_clean/feature/user/domain/usecase/isLogin_usecase.dart';
import 'package:instagram_clean/feature/user/domain/usecase/login_usecase.dart';
import 'package:meta/meta.dart';



part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginUseCase loginUseCase;
  IsLoginUseCase isLoginUseCase;
  GetCurrentUserIdUseCase getCurrentUserIdUseCase;
  
  LoginCubit({required this.loginUseCase,required this.isLoginUseCase,required this.getCurrentUserIdUseCase}) : super(LoginInitial());

  // Future<void> checkIsLogin()async{
  //   try {
  //     bool isSignIn = await isLoginUseCase.call();
  //     if (isSignIn == true) {
  //
  //       final uid = await getCurrentUserIdUseCase.call();
  //       emit(LoginSuccess(uid: uid));
  //     } else {
  //       emit(LoginFailed("this user not login"));
  //     }
  //   } catch(_) {
  //     emit(LoginFailed("error in checkIsLogin func"));
  //   }
  //
  // }

  Future<void> login(UserEntity user) async {
    if (!Constant.reformKey.currentState!.validate()) {
      emit(LoginFailed("Please enter your info"));
      return;
    }
    emit(LoginLoading());
    try {
      await loginUseCase.call(user);
      emit(LoginSuccess(uid: user.uid!));
    } catch (error) {
      emit(LoginFailed("$error is error"));
    }
  }
}
