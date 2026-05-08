import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

/// Production-grade Auth Interceptor.
///
/// Responsibilities:
/// 1. Attach access token to every outgoing request.
/// 2. On 401 Unauthorized → silently refresh the token using refreshToken.
/// 3. Queue all concurrent requests during token refresh to prevent race conditions.
/// 4. Retry the original failed request with the new token.
/// 5. If refresh itself fails → force logout the user cleanly.
class AuthInterceptor extends QueuedInterceptor {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  /// Callback set by the app layer (usually AuthBloc) to handle forced logout.
  final void Function()? onForceLogout;

  /// Whether a token refresh is currently in progress.
  bool _isRefreshing = false;

  /// Completer that concurrent 401-blocked requests wait on.
  Completer<String?>? _refreshCompleter;

  AuthInterceptor({
    required Dio dio,
    FlutterSecureStorage? storage,
    this.onForceLogout,
  })  : _dio = dio,
        _storage = storage ?? const FlutterSecureStorage();

  // ─────────────────────────────────────────────
  // 1. Attach Access Token
  // ─────────────────────────────────────────────
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.read(key: AppConstants.accessTokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    debugPrint('🌐 [${options.method}] ${options.baseUrl}${options.path}');
    handler.next(options);
  }

  // ─────────────────────────────────────────────
  // 2. Log Response
  // ─────────────────────────────────────────────
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
        '✅ [${response.statusCode}] ${response.requestOptions.path}');
    handler.next(response);
  }

  // ─────────────────────────────────────────────
  // 3. Handle 401 → Silent Refresh → Retry
  // ─────────────────────────────────────────────
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint(
        '❌ [${err.response?.statusCode}] ${err.requestOptions.path} — ${err.message}');

    // Only intercept 401 errors, and never for the refresh endpoint itself.
    if (err.response?.statusCode != 401 ||
        err.requestOptions.path.contains('/auth/refresh') ||
        err.requestOptions.path.contains('/auth/login')) {
      return handler.next(err);
    }

    // ── Attempt Token Refresh ──
    try {
      final newToken = await _refreshAccessToken();

      if (newToken != null) {
        // Retry the original request with the new token.
        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer $newToken';

        final retryResponse = await _dio.fetch(opts);
        return handler.resolve(retryResponse);
      }
    } catch (e) {
      debugPrint('❌ Retry after refresh failed: $e');
    }

    // If we reach here, refresh failed entirely → force logout.
    await _clearTokensAndForceLogout();
    handler.next(err);
  }

  // ─────────────────────────────────────────────
  // Token Refresh Logic (with queue guard)
  // ─────────────────────────────────────────────

  /// Attempts to refresh the access token.
  /// If a refresh is already in progress, waits for it to complete
  /// and returns the new token (preventing parallel refresh calls).
  Future<String?> _refreshAccessToken() async {
    // If another call is already refreshing, just wait for its result.
    if (_isRefreshing) {
      debugPrint('⏳ Token refresh already in progress — waiting...');
      return _refreshCompleter?.future;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<String?>();

    try {
      final refreshToken =
          await _storage.read(key: AppConstants.refreshTokenKey);

      if (refreshToken == null || refreshToken.isEmpty) {
        debugPrint('❌ No refresh token found in secure storage.');
        _refreshCompleter?.complete(null);
        return null;
      }

      // Use a bare Dio instance to avoid interceptor loops.
      final cleanDio = Dio(BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ));

      debugPrint('🔄 Attempting silent token refresh...');
      final response = await cleanDio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newAccessToken = response.data['accessToken'] as String?;
        final newRefreshToken = response.data['refreshToken'] as String?;

        if (newAccessToken != null) {
          await _storage.write(
              key: AppConstants.accessTokenKey, value: newAccessToken);
          if (newRefreshToken != null) {
            await _storage.write(
                key: AppConstants.refreshTokenKey, value: newRefreshToken);
          }
          debugPrint('✅ Token refreshed successfully.');
          _refreshCompleter?.complete(newAccessToken);
          return newAccessToken;
        }
      }

      debugPrint('❌ Refresh response did not contain a valid access token.');
      _refreshCompleter?.complete(null);
      return null;
    } catch (e) {
      debugPrint('❌ Token refresh request failed: $e');
      _refreshCompleter?.complete(null);
      return null;
    } finally {
      _isRefreshing = false;
    }
  }

  // ─────────────────────────────────────────────
  // Force Logout
  // ─────────────────────────────────────────────

  Future<void> _clearTokensAndForceLogout() async {
    debugPrint('🔒 Clearing tokens and forcing logout...');
    await _storage.delete(key: AppConstants.accessTokenKey);
    await _storage.delete(key: AppConstants.refreshTokenKey);
    onForceLogout?.call();
  }
}
