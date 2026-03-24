import 'package:equatable/equatable.dart';

/// User model
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

  /// Parse from backend API JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      role: json['role'] as String? ?? 'CUSTOMER',
      orderCount: (json['orders'] as List?)?.length ?? json['_count']?['orders'] as int? ?? 0,
      addressCount: (json['addresses'] as List?)?.length ?? json['_count']?['addresses'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, email, name];
}
