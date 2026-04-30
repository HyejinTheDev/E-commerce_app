import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/dio_client.dart';

/// Remote data source for authentication API calls.
/// Handles raw HTTP requests and token persistence.
class AuthRemoteDataSource {
  final DioClient _client;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const _roleKey = 'user_role';
  static const _nameKey = 'user_name';

  AuthRemoteDataSource(this._client);

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _client.dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    String? phone,
    String role = 'CUSTOMER',
    String? shopName,
    String? shopDescription,
    String? vehicleType,
    String? licensePlate,
  }) async {
    final response = await _client.dio.post('/auth/register', data: {
      'email': email,
      'password': password,
      'name': name,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
      'role': role,
      if (shopName != null) 'shopName': shopName,
      if (shopDescription != null) 'shopDescription': shopDescription,
      if (vehicleType != null) 'vehicleType': vehicleType,
      if (licensePlate != null) 'licensePlate': licensePlate,
    });
    return response.data as Map<String, dynamic>;
  }

  Future<void> saveTokens(Map<String, dynamic> data) async {
    await _storage.write(
      key: AppConstants.accessTokenKey,
      value: data['accessToken'] as String,
    );
    await _storage.write(
      key: AppConstants.refreshTokenKey,
      value: data['refreshToken'] as String,
    );
    // Save user info
    final user = data['user'] as Map<String, dynamic>?;
    if (user != null) {
      await _storage.write(key: _roleKey, value: user['role'] as String?);
      await _storage.write(key: _nameKey, value: user['name'] as String?);
    }
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: AppConstants.accessTokenKey);
    await _storage.delete(key: AppConstants.refreshTokenKey);
    await _storage.delete(key: _roleKey);
    await _storage.delete(key: _nameKey);
  }

  Future<String?> getAccessToken() async {
    return _storage.read(key: AppConstants.accessTokenKey);
  }

  Future<String?> getSavedRole() async {
    return _storage.read(key: _roleKey);
  }

  Future<String?> getSavedName() async {
    return _storage.read(key: _nameKey);
  }

  Future<bool> hasToken() async {
    final token = await _storage.read(key: AppConstants.accessTokenKey);
    return token != null && token.isNotEmpty;
  }
}
