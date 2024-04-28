import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocDI extends StatelessWidget {
  const BlocDI({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider<AppCubit>(
        //   create: (context) => AppCubit(sl(), sl())..init(),
        // ),
        // BlocProvider<UserCubit>(
        //   create: (context) =>
        //       UserCubit(userAccountRepository: sl(), authRepository: sl()),
        // ),
        // BlocProvider<DashboardCubit>(
        //   create: (context) => DashboardCubit(),
        // ),
        // BlocProvider<StepperCubit>(
        //   create: (context) => StepperCubit(),
        // ),
        // BlocProvider<GetListsCubit>(
        //   create: (context) => GetListsCubit(sl()),
        // ),
        // BlocProvider<GetSpecialScheduleCubit>(
        //   create: (context) => GetSpecialScheduleCubit(sl()),
        // ),
        // BlocProvider<AddSpecialScheduleCubit>(
        //   create: (context) => AddSpecialScheduleCubit(sl()),
        // ),
        // BlocProvider<SocketCubit>(
        //   create: (context) => SocketCubit(socketRepository:sl()),
        // ),BlocProvider<ConversationCubit>(
        //   create: (context) => ConversationCubit(socketRepository:sl()),
        // ),BlocProvider<ChatAttachmentCubit>(
        //   create: (context) => ChatAttachmentCubit(sl()),
        // ),BlocProvider<UpdateProfileCubit>(
        //   create: (context) => UpdateProfileCubit(sl()),
        // ),
      ],
      child: child,
    );
  }
}
