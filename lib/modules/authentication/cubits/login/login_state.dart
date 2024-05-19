

import 'package:equatable/equatable.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum LoginStatus {
  initial,
  loading,
  success,
  userNotFound,
  error,
}

class LoginState extends Equatable {
  final LoginStatus loginStatus;
  final bool isPasswordHidden;
  final bool isAutoValidate;
  final String message;
  final GoogleSignInAccount? googleUser;
  final int roleId;

  LoginState({
    required this.loginStatus,
    required this.isPasswordHidden,
    required this.isAutoValidate,
    required this.message,
    required this.googleUser,
    required this.roleId,
  });

  factory LoginState.initial() {
    return LoginState(
      loginStatus: LoginStatus.initial,
      isPasswordHidden: true,
      isAutoValidate: false,
      message: '',
      googleUser: null,
      roleId: -1,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [loginStatus, isPasswordHidden, isAutoValidate];

  LoginState copyWith({
    LoginStatus? loginStatus,
    bool? isPasswordHidden,
    bool? isAutoValidate,
    String? message,
    GoogleSignInAccount? googleUser,
    int? roleId,
  }) {
    return LoginState(
      loginStatus: loginStatus ?? this.loginStatus,
      isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
      isAutoValidate: isAutoValidate ?? this.isAutoValidate,
      message: message ?? this.message,
      googleUser: googleUser ?? this.googleUser,
      roleId: roleId ?? this.roleId,
    );
  }
}
