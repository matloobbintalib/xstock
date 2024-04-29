import 'package:bloc/bloc.dart';
import 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupState.initial());

  void toggleShowPassword() => emit(state.copyWith(
    isPasswordHidden: !state.isPasswordHidden,
    signupStatus: SignupStatus.initial,
  ));

  void enableAutoValidateMode() => emit(state.copyWith(
    isAutoValidate: true,
    signupStatus: SignupStatus.initial,
  ));
}
