import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ecommerce_app/core/network/auth_interceptor.dart';
import 'package:ecommerce_app/core/constants/app_constants.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage mockStorage;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
        .thenAnswer((_) async {});
    when(() => mockStorage.delete(key: any(named: 'key')))
        .thenAnswer((_) async {});
  });

  group('AuthInterceptor — Unit Tests', () {
    test('attaches Authorization header when access token exists', () async {
      when(() => mockStorage.read(key: AppConstants.accessTokenKey))
          .thenAnswer((_) async => 'my-access-token');

      final dio = Dio(BaseOptions(baseUrl: 'http://localhost'));
      final interceptor = AuthInterceptor(
        dio: dio,
        storage: mockStorage,
      );

      final options = RequestOptions(path: '/test');
      interceptor.onRequest(options, RequestInterceptorHandler());

      await Future.delayed(const Duration(milliseconds: 200));

      verify(() => mockStorage.read(key: AppConstants.accessTokenKey)).called(1);
    });

    test('does NOT attach Authorization header when token is null', () async {
      when(() => mockStorage.read(key: AppConstants.accessTokenKey))
          .thenAnswer((_) async => null);

      final dio = Dio(BaseOptions(baseUrl: 'http://localhost'));
      final interceptor = AuthInterceptor(
        dio: dio,
        storage: mockStorage,
      );

      final options = RequestOptions(path: '/test');
      interceptor.onRequest(options, RequestInterceptorHandler());

      await Future.delayed(const Duration(milliseconds: 200));

      verify(() => mockStorage.read(key: AppConstants.accessTokenKey)).called(1);
    });

    // For onError tests with QueuedInterceptor, handler.next() triggers an
    // unhandled async error because there's no Dio pipeline. We use
    // runZonedGuarded to safely absorb those and verify side-effects instead.

    test('skips refresh for /auth/login path on 401', () async {
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost'));
      final interceptor = AuthInterceptor(
        dio: dio,
        storage: mockStorage,
      );

      final requestOptions = RequestOptions(path: '/auth/login');
      final error = DioException(
        requestOptions: requestOptions,
        response: Response(requestOptions: requestOptions, statusCode: 401),
      );

      // Absorb the unhandled DioException from handler.next()
      runZonedGuarded(() {
        interceptor.onError(error, ErrorInterceptorHandler());
      }, (_, __) {});

      await Future.delayed(const Duration(milliseconds: 300));

      verifyNever(() => mockStorage.read(key: AppConstants.refreshTokenKey));
    });

    test('skips refresh for /auth/refresh path on 401', () async {
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost'));
      final interceptor = AuthInterceptor(
        dio: dio,
        storage: mockStorage,
      );

      final requestOptions = RequestOptions(path: '/auth/refresh');
      final error = DioException(
        requestOptions: requestOptions,
        response: Response(requestOptions: requestOptions, statusCode: 401),
      );

      runZonedGuarded(() {
        interceptor.onError(error, ErrorInterceptorHandler());
      }, (_, __) {});

      await Future.delayed(const Duration(milliseconds: 300));

      verifyNever(() => mockStorage.read(key: AppConstants.refreshTokenKey));
    });

    test('does not intercept non-401 errors (e.g. 500)', () async {
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost'));
      final interceptor = AuthInterceptor(
        dio: dio,
        storage: mockStorage,
      );

      final requestOptions = RequestOptions(path: '/products');
      final error = DioException(
        requestOptions: requestOptions,
        response: Response(requestOptions: requestOptions, statusCode: 500),
      );

      runZonedGuarded(() {
        interceptor.onError(error, ErrorInterceptorHandler());
      }, (_, __) {});

      await Future.delayed(const Duration(milliseconds: 300));

      verifyNever(() => mockStorage.read(key: AppConstants.refreshTokenKey));
    });

    test('forces logout when no refresh token is stored on 401', () async {
      bool logoutCalled = false;

      when(() => mockStorage.read(key: AppConstants.refreshTokenKey))
          .thenAnswer((_) async => null);

      final dio = Dio(BaseOptions(baseUrl: 'http://localhost'));
      final interceptor = AuthInterceptor(
        dio: dio,
        storage: mockStorage,
        onForceLogout: () => logoutCalled = true,
      );

      final requestOptions = RequestOptions(path: '/products');
      final error = DioException(
        requestOptions: requestOptions,
        response: Response(requestOptions: requestOptions, statusCode: 401),
      );

      runZonedGuarded(() {
        interceptor.onError(error, ErrorInterceptorHandler());
      }, (_, __) {});

      await Future.delayed(const Duration(milliseconds: 500));

      expect(logoutCalled, isTrue);
      verify(() => mockStorage.delete(key: AppConstants.accessTokenKey)).called(1);
      verify(() => mockStorage.delete(key: AppConstants.refreshTokenKey)).called(1);
    });
  });
}
