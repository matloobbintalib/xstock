

import 'package:equatable/equatable.dart';

enum LoginStatus {
  initial,
  loading,
  success,
  error,
}

class LoginState extends Equatable {
  final LoginStatus loginStatus;
  final bool isPasswordHidden;
  final bool isAutoValidate;
  final String message;
  final int roleId;

  LoginState({
    required this.loginStatus,
    required this.isPasswordHidden,
    required this.isAutoValidate,
    required this.message,
    required this.roleId,
  });

  factory LoginState.initial() {
    return LoginState(
      loginStatus: LoginStatus.initial,
      isPasswordHidden: true,
      isAutoValidate: false,
      message: '',
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
    String? errorMessage,
    int? roleId,
  }) {
    return LoginState(
      loginStatus: loginStatus ?? this.loginStatus,
      isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
      isAutoValidate: isAutoValidate ?? this.isAutoValidate,
      message: errorMessage ?? this.message,
      roleId: roleId ?? this.roleId,
    );
  }
}
