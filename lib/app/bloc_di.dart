import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xstock/app/app_cubit.dart';
import 'package:xstock/core/di/service_locator.dart';
import 'package:xstock/modules/common/image_picker/image_picker_cubit.dart';
import 'package:xstock/modules/common/repo/image_picker_repo.dart';
import 'package:xstock/modules/home/cubits/group_streams/group_streams_cubit.dart';
import 'package:xstock/modules/home/cubits/items_streams/items_streams_cubit.dart';
import 'package:xstock/modules/home/cubits/send_notification/send_notification_cubit.dart';
import 'package:xstock/modules/user/cubits/user_cubit.dart';

class BlocDI extends StatelessWidget {
  const BlocDI({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>(
          create: (context) => AppCubit( sl())..init(),
        ),
        BlocProvider<ImagePickerCubit>(
          create: (context) => ImagePickerCubit(ImagePickerRepo()),
        ),
        BlocProvider<UserCubit>(
          create: (context) => UserCubit(userAccountRepository: sl()),
        ),
        BlocProvider<GroupStreamsCubit>(
          create: (context) => GroupStreamsCubit(),
        ),BlocProvider<ItemsStreamsCubit>(
          create: (context) => ItemsStreamsCubit(),
        ),
        BlocProvider(
          create: (context) => NotificationCubit(sl()),
        ),
      ],
      child: child,
    );
  }
}
