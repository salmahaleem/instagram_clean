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

  Future<void> checkIsLogin()async{
    try {
      bool isSignIn = await isLoginUseCase.call();
      if (isSignIn == true) {
        final uid = await getCurrentUserIdUseCase.call();
        UserEntity user = UserEntity(uid: uid);
        emit(LoginSuccess(user));
      } else {
        emit(LoginFailed("this user not login"));
      }
    } catch(e) {
       emit(LoginFailed("Error checking login status: $e"));
    }
  }
  Future<void> login() async {
    final email = Constant.email.text.trim();
    final password = Constant.password.text.trim();
    if (email.isEmpty || password.isEmpty) {
      emit(LoginFailed("Email and Password cannot be empty"));
      return;
    }
    UserEntity user = UserEntity(email: email, password: password);
    emit(LoginLoading());
    try {
      await loginUseCase.call(user);
      emit(LoginSuccess(user));
    } catch (e) {
      emit(LoginFailed("Login Failed: $e"));
    }
  }
}
