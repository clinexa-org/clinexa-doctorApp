import 'package:dio/dio.dart';
import '../../storage/cache_helper.dart';

class AuthInterceptor extends Interceptor {
  final CacheHelper cacheHelper;
  final void Function()? onUnauthorized;

  AuthInterceptor(this.cacheHelper, {this.onUnauthorized});

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await cacheHelper.readToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token'; // Standard format
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      onUnauthorized?.call();
    }
    super.onError(err, handler);
  }
}
