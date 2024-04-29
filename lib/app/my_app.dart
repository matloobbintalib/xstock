import 'dart:math' as math;

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xstock/config/routes/nav_router.dart';
import 'package:xstock/config/themes/light_theme.dart';
import 'package:xstock/modules/startup/splash_page.dart';
import 'package:xstock/ui/widgets/unfocus.dart';

import 'app_cubit.dart';
import 'bloc_di.dart';

const double degrees2Radians = math.pi / 180.0;

class XStockApp extends StatelessWidget {
  const XStockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocDI(
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          return MaterialApp(
            navigatorKey: NavRouter.navigationKey,
            title: 'XStock',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            themeMode: ThemeMode.light,
            builder: (BuildContext context, Widget? child) {
              child = BotToastInit()(context, child);
              child = UnFocus(child: child);
              return child;
            },
            navigatorObservers: [
              BotToastNavigatorObserver(),
            ],
            home: SplashPage(),
            locale: state.locale,
          );
        },
      ),
    );
  }
}
