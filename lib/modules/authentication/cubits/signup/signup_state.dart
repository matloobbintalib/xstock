

import 'package:equatable/equatable.dart';
import 'package:xstock/modules/authentication/models/user_model.dart';

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
  final UserModel userModel;

  SignupState({
    required this.signupStatus,
    required this.isPasswordHidden,
    required this.isAutoValidate,
    required this.message,
    required this.roleId,
    required this.userModel
  });

  factory SignupState.initial() {
    return SignupState(
      signupStatus: SignupStatus.initial,
      isPasswordHidden: true,
      isAutoValidate: false,
      message: '',
      roleId: -1,
      userModel: UserModel.empty
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
    String? message,
    int? roleId,
    UserModel? userModel
  }) {
    return SignupState(
      signupStatus: signupStatus ?? this.signupStatus,
      isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
      isAutoValidate: isAutoValidate ?? this.isAutoValidate,
      message: message ?? this.message,
      roleId: roleId ?? this.roleId,
      userModel: userModel ?? this.userModel
    );
  }
}
