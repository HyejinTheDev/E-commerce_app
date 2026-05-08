import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';
import 'auth_interceptor.dart';

/// Centralized Dio HTTP Client.
///
/// Uses [AuthInterceptor] (extends [QueuedInterceptor]) to:
/// - Auto-attach access tokens to every request.
/// - Silently refresh expired tokens on 401 responses.
/// - Queue concurrent requests during token refresh.
/// - Force logout only when refresh itself fails.
class DioClient {
  late final Dio dio;
  late final AuthInterceptor _authInterceptor;

  /// Callback set by AuthBloc to handle forced logout.
  /// Propagated to [AuthInterceptor].
  static void Function()? onForceLogout;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    _authInterceptor = AuthInterceptor(
      dio: dio,
      storage: const FlutterSecureStorage(),
      onForceLogout: () => onForceLogout?.call(),
    );

    dio.interceptors.add(_authInterceptor);
  }
}
