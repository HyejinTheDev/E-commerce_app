import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/usecases/usecase.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/register_usecase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../domain/usecases/check_auth_usecase.dart';
import '../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final CheckAuthUseCase _checkAuthUseCase;
  final AuthRepository _authRepository;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required CheckAuthUseCase checkAuthUseCase,
    required AuthRepository authRepository,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _checkAuthUseCase = checkAuthUseCase,
        _authRepository = authRepository,
        super(const AuthState()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckRequested(
      AuthCheckRequested event, Emitter<AuthState> emit) async {
    final isLoggedIn = await _checkAuthUseCase(const NoParams());
    if (isLoggedIn) {
      // Restore saved role
      final role = await _authRepository.getSavedRole();
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        userRole: role ?? 'CUSTOMER',
      ));
    } else {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> _onLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final userInfo = await _loginUseCase(LoginParams(event.email, event.password));
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        userRole: userInfo['role'] as String? ?? 'CUSTOMER',
        userName: userInfo['name'] as String?,
      ));
    } catch (e) {
      String message = 'Login failed';
      if (e.toString().contains('401')) {
        message = 'Email hoặc mật khẩu không đúng';
      } else if (e.toString().contains('connection')) {
        message = 'Không thể kết nối server';
      }
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: message,
      ));
    }
  }

  Future<void> _onRegisterRequested(
      AuthRegisterRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final userInfo = await _registerUseCase(RegisterParams(
        email: event.email,
        password: event.password,
        name: event.name,
        phone: event.phone,
        role: event.role,
        shopName: event.shopName,
        shopDescription: event.shopDescription,
        vehicleType: event.vehicleType,
        licensePlate: event.licensePlate,
      ));
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        userRole: userInfo['role'] as String? ?? event.role,
        userName: userInfo['name'] as String? ?? event.name,
      ));
    } catch (e) {
      String message = 'Registration failed';
      if (e.toString().contains('409')) {
        message = 'Email đã được sử dụng';
      } else if (e.toString().contains('connection')) {
        message = 'Không thể kết nối server';
      }
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: message,
      ));
    }
  }

  Future<void> _onLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    await _logoutUseCase(const NoParams());
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
