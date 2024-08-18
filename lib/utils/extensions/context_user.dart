import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xstock/modules/authentication/models/user_model.dart';
import 'package:xstock/modules/user/cubits/user_cubit.dart';


extension BuildContextUserExt on BuildContext {
  UserModel get watchCurrentUser {
    final userState = watch<UserCubit>().state;
    return userState.userModel;
  }

  UserModel get getCurrentUser {
    final userState = read<UserCubit>().state;
    return userState.userModel;
  }
}