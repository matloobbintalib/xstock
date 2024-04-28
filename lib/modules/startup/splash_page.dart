import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:xstock/config/routes/nav_router.dart';

import '../../constants/asset_paths.dart';
import '../../core/core.dart';
import 'startup_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StartupCubit(
        sessionRepository: sl(),
      )..init(),
      child: BlocListener<StartupCubit, StartupState>(
        listener: (context, state) {
          if (state.status == Status.authenticated) {
            // context.read<UserCubit>().loadUser();
            // var user = context.read<UserCubit>().state.userModel;
            // NavRouter.pushAndRemoveUntil(context, Dashboard(userId: user.advisor.userId.toString(),));
          } else if (state.status == Status.unauthenticated) {
            // NavRouter.pushAndRemoveUntilWithAnimation(context, LoginPage(),
            //     type: PageTransitionType.size, hasAlignment: true);
          }
        },
        child: Scaffold(
          body: Image.asset(
            AssetPaths.splashBackground,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ),
      ),
    );
  }
}
