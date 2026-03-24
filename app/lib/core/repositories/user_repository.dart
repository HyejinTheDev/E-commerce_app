import '../models/user.dart';
import '../network/dio_client.dart';

/// Repository for user-related API calls
class UserRepository {
  final DioClient _client;

  UserRepository(this._client);

  /// Get current user's profile
  /// GET /users/profile (requires auth)
  Future<User> getProfile() async {
    final response = await _client.dio.get('/users/profile');
    return User.fromJson(response.data as Map<String, dynamic>);
  }

  /// Update current user's profile
  /// PATCH /users/profile (requires auth)
  Future<User> updateProfile(Map<String, dynamic> data) async {
    final response = await _client.dio.patch('/users/profile', data: data);
    return User.fromJson(response.data as Map<String, dynamic>);
  }

  /// Get user's addresses
  /// GET /users/addresses (requires auth)
  Future<List<Map<String, dynamic>>> getAddresses() async {
    final response = await _client.dio.get('/users/addresses');
    return (response.data as List<dynamic>).cast<Map<String, dynamic>>();
  }
}
