import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ecommerce_app/features/auth/bloc/auth_bloc.dart';
import 'package:ecommerce_app/features/auth/bloc/auth_event.dart';
import 'package:ecommerce_app/features/auth/bloc/auth_state.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:ecommerce_app/core/usecases/usecase.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockRegisterUseCase extends Mock implements RegisterUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}
class MockCheckAuthUseCase extends Mock implements CheckAuthUseCase {}
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthBloc authBloc;
  late MockLoginUseCase mockLoginUseCase;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockCheckAuthUseCase mockCheckAuthUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockRegisterUseCase = MockRegisterUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockCheckAuthUseCase = MockCheckAuthUseCase();
    mockAuthRepository = MockAuthRepository();

    authBloc = AuthBloc(
      loginUseCase: mockLoginUseCase,
      registerUseCase: mockRegisterUseCase,
      logoutUseCase: mockLogoutUseCase,
      checkAuthUseCase: mockCheckAuthUseCase,
      authRepository: mockAuthRepository,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc Tests', () {
    test('initial state should be AuthState with status initial', () {
      expect(authBloc.state.status, AuthStatus.initial);
    });

    blocTest<AuthBloc, AuthState>(
      'emits [authenticated] when AuthCheckRequested succeeds',
      build: () {
        when(() => mockCheckAuthUseCase(const NoParams()))
            .thenAnswer((_) async => true);
        when(() => mockAuthRepository.getSavedRole())
            .thenAnswer((_) async => 'CUSTOMER');
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthCheckRequested()),
      expect: () => [
        const AuthState(status: AuthStatus.authenticated, userRole: 'CUSTOMER'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [unauthenticated] when AuthCheckRequested fails',
      build: () {
        when(() => mockCheckAuthUseCase(const NoParams()))
            .thenAnswer((_) async => false);
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthCheckRequested()),
      expect: () => [
        const AuthState(status: AuthStatus.unauthenticated),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [loading, authenticated] when AuthLoginRequested succeeds',
      build: () {
        when(() => mockLoginUseCase(any()))
            .thenAnswer((_) async => {'role': 'CUSTOMER', 'name': 'John Doe'});
        return authBloc;
      },
      setUp: () {
        registerFallbackValue(const LoginParams('test@test.com', 'password'));
      },
      act: (bloc) => bloc.add(const AuthLoginRequested('test@test.com', 'password')),
      expect: () => [
        const AuthState(status: AuthStatus.loading),
        const AuthState(
          status: AuthStatus.authenticated,
          userRole: 'CUSTOMER',
          userName: 'John Doe',
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [loading, error] when AuthLoginRequested fails',
      build: () {
        when(() => mockLoginUseCase(any())).thenThrow(Exception('Login failed'));
        return authBloc;
      },
      setUp: () {
        registerFallbackValue(const LoginParams('test@test.com', 'password'));
      },
      act: (bloc) => bloc.add(const AuthLoginRequested('test@test.com', 'password')),
      expect: () => [
        const AuthState(status: AuthStatus.loading),
        const AuthState(
          status: AuthStatus.error,
          errorMessage: 'Login failed',
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [unauthenticated] when AuthLogoutRequested succeeds',
      build: () {
        when(() => mockLogoutUseCase(const NoParams()))
            .thenAnswer((_) async => {});
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthLogoutRequested()),
      expect: () => [
        const AuthState(status: AuthStatus.unauthenticated),
      ],
    );
  });
}
