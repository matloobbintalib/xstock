import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:xstock/config/routes/nav_router.dart';
import 'package:xstock/modules/authentication/pages/login_page.dart';
import 'package:xstock/modules/home/pages/home_page.dart';
import 'package:xstock/modules/startup/welcome_page.dart';
import 'package:xstock/utils/extensions/extended_context.dart';

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
            NavRouter.pushAndRemoveUntilWithAnimation(context, HomePage(),
                type: PageTransitionType.size, hasAlignment: true);
          } else if (state.status == Status.unauthenticated) {
            NavRouter.pushAndRemoveUntilWithAnimation(context, WelcomePage(),
                type: PageTransitionType.size, hasAlignment: true);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Image.asset(
                'assets/images/png/splash_video.gif'
            ),
          ),
        ),
      ),
    );
  }
}
