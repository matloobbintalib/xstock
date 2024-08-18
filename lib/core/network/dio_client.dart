import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import '../../config/environment.dart';
import '../../config/routes/nav_router.dart';
import '../../modules/authentication/pages/login_page.dart';

class DioClient extends DioForNative {
  Environment _environment;

  DioClient({
    required Environment environment,
  })  : _environment = environment {
    options = BaseOptions(
      baseUrl: _environment.baseUrl,
      responseType: ResponseType.json,
    );

    interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
    ));
  }
}
