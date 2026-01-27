import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../config/env.dart';
import '../storage/cache_helper.dart';
import 'interceptors/auth_interceptor.dart';

class DioFactory {
  final CacheHelper cacheHelper;
  final bool isProd;
  final void Function()? onUnauthorized;

  DioFactory({
    required this.cacheHelper,
    required this.isProd,
    this.onUnauthorized,
  });

  Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(AuthInterceptor(
      cacheHelper,
      onUnauthorized: onUnauthorized,
    ));

    if (!isProd) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 90,
      ));
    }

    return dio;
  }
}
