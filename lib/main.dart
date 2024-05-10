import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xstock/app/app_bloc_observer.dart';
import 'package:xstock/app/my_app.dart';
import 'package:xstock/config/environment.dart';
import 'package:xstock/core/initializer/init_app.dart';
import 'package:xstock/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  HttpOverrides.global = MyHttpOverrides();
  Bloc.observer = AppBlocObserver();

  await initApp(Environment.fromEnv(AppEnv.dev));

  runApp(const XStockApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
