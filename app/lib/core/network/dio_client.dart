import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

class DioClient {
  late final Dio dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Callback set by AuthBloc to handle forced logout
  static void Function()? onForceLogout;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: AppConstants.accessTokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          print('🌐 DIO REQUEST: ${options.method} ${options.baseUrl}${options.path}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ DIO RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
          handler.next(response);
        },
        onError: (error, handler) async {
          print('❌ DIO ERROR: ${error.type} ${error.message} ${error.requestOptions.path}');
          
          if (error.response?.statusCode == 401 && !error.requestOptions.path.contains('/auth/refresh')) {
            // Token expired — attempt to refresh
            try {
              final refreshToken = await _storage.read(key: AppConstants.refreshTokenKey);
              if (refreshToken != null) {
                // Use a separate Dio instance to prevent interceptor loop
                final cloneDio = Dio(BaseOptions(baseUrl: AppConstants.baseUrl));
                final refreshResponse = await cloneDio.post(
                  '/auth/refresh',
                  data: {'refreshToken': refreshToken},
                );

                if (refreshResponse.statusCode == 200) {
                  final newAccessToken = refreshResponse.data['accessToken'];
                  final newRefreshToken = refreshResponse.data['refreshToken'];

                  await _storage.write(key: AppConstants.accessTokenKey, value: newAccessToken);
                  if (newRefreshToken != null) {
                    await _storage.write(key: AppConstants.refreshTokenKey, value: newRefreshToken);
                  }

                  // Update header and retry the failed request
                  error.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
                  
                  // Return the re-fetched request
                  final retryResponse = await cloneDio.fetch(error.requestOptions);
                  return handler.resolve(retryResponse);
                }
              }
            } catch (e) {
              print('❌ Token Refresh Failed: $e');
              // Proceed to force logout if refresh also fails
            }
            
            // If all fails or no refresh token
            await _storage.delete(key: AppConstants.accessTokenKey);
            await _storage.delete(key: AppConstants.refreshTokenKey);
            onForceLogout?.call();
          }
          
          handler.next(error);
        },
      ),
    );
  }
}
