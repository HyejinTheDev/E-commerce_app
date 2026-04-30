import 'package:equatable/equatable.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? errorMessage;
  final String? userRole; // CUSTOMER, SELLER, DELIVERY, ADMIN
  final String? userName;

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.userRole,
    this.userName,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    String? userRole,
    String? userName,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      userRole: userRole ?? this.userRole,
      userName: userName ?? this.userName,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isSeller => userRole == 'SELLER';
  bool get isDelivery => userRole == 'DELIVERY';
  bool get isCustomer => userRole == 'CUSTOMER' || userRole == null;

  @override
  List<Object?> get props => [status, errorMessage, userRole, userName];
}
