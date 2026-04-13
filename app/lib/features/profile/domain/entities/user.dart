import 'package:equatable/equatable.dart';

/// Pure User entity — Domain Layer
class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? avatar;
  final String role;
  final int orderCount;
  final int addressCount;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.avatar,
    this.role = 'CUSTOMER',
    this.orderCount = 0,
    this.addressCount = 0,
  });

  @override
  List<Object?> get props => [id, email, name];
}
