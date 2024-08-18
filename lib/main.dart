import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
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

Future<String> getDeviceUUID() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id; // UUID for Android
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    if (iosInfo.identifierForVendor != null) {
      return iosInfo.identifierForVendor.toString(); // UUID for iOS
    } else {
      return '';
    }
  } else {
    return '';
  }
}
