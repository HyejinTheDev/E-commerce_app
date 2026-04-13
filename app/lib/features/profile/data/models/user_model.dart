import '../../domain/entities/user.dart';

/// UserModel — data layer JSON deserialization
class UserModel {
  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      role: json['role'] as String? ?? 'CUSTOMER',
      orderCount: (json['orders'] as List?)?.length ??
          json['_count']?['orders'] as int? ??
          0,
      addressCount: (json['addresses'] as List?)?.length ??
          json['_count']?['addresses'] as int? ??
          0,
    );
  }
}
