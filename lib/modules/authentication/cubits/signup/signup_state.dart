

import 'package:equatable/equatable.dart';

enum SignupStatus {
  initial,
  loading,
  success,
  error,
}

class SignupState extends Equatable {
  final SignupStatus signupStatus;
  final bool isPasswordHidden;
  final bool isAutoValidate;
  final String message;
  final int roleId;

  SignupState({
    required this.signupStatus,
    required this.isPasswordHidden,
    required this.isAutoValidate,
    required this.message,
    required this.roleId,
  });

  factory SignupState.initial() {
    return SignupState(
      signupStatus: SignupStatus.initial,
      isPasswordHidden: true,
      isAutoValidate: false,
      message: '',
      roleId: -1,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [signupStatus, isPasswordHidden, isAutoValidate];

  SignupState copyWith({
    SignupStatus? signupStatus,
    bool? isPasswordHidden,
    bool? isAutoValidate,
    String? errorMessage,
    int? roleId,
  }) {
    return SignupState(
      signupStatus: signupStatus ?? this.signupStatus,
      isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
      isAutoValidate: isAutoValidate ?? this.isAutoValidate,
      message: errorMessage ?? this.message,
      roleId: roleId ?? this.roleId,
    );
  }
}
