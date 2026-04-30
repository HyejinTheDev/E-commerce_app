import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

/// Check if user is already logged in (app startup)
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Login with email and password
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  const AuthLoginRequested(this.email, this.password);
  @override
  List<Object?> get props => [email, password];
}

/// Register a new account
class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String? phone;
  final String role; // CUSTOMER, SELLER, DELIVERY
  // Seller-specific
  final String? shopName;
  final String? shopDescription;
  // Delivery-specific
  final String? vehicleType;
  final String? licensePlate;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.name,
    this.phone,
    this.role = 'CUSTOMER',
    this.shopName,
    this.shopDescription,
    this.vehicleType,
    this.licensePlate,
  });
  @override
  List<Object?> get props => [email, password, name, phone, role];
}

/// Logout
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
