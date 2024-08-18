part of 'user_cubit.dart';

enum UserStatus {
  initial,
  loading,
  loginOut,
  logout,
  success,
  error,
}

class UserState extends Equatable {
  final UserStatus userStatus;
  final UserModel userModel;
  final String message;

  UserState({
    required this.userStatus,
    required this.userModel,
    required this.message,
  });

  factory UserState.initial() {
    return UserState(
      userStatus: UserStatus.initial,
      userModel: UserModel.empty,
        message:''
    );
  }

  UserState copyWith({UserStatus? userStatus, UserModel? userModel, String? message}) {
    return UserState(
      userModel: userModel ?? this.userModel,
      userStatus: userStatus ?? this.userStatus,
      message: message ?? this.message,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [userModel, userStatus];
}
