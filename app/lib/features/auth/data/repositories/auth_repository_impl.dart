import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Concrete implementation of [AuthRepository]
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final data = await _remoteDataSource.login(email, password);
    await _remoteDataSource.saveTokens(data);
    final user = data['user'] as Map<String, dynamic>? ?? {};
    return {'role': user['role'] ?? 'CUSTOMER', 'name': user['name'] ?? ''};
  }

  @override
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
    final data = await _remoteDataSource.register(
      email: email,
      password: password,
      name: name,
      phone: phone,
      role: role,
      shopName: shopName,
      shopDescription: shopDescription,
      vehicleType: vehicleType,
      licensePlate: licensePlate,
    );
    await _remoteDataSource.saveTokens(data);
    final user = data['user'] as Map<String, dynamic>? ?? {};
    return {'role': user['role'] ?? role, 'name': user['name'] ?? name};
  }

  @override
  Future<void> logout() async {
    await _remoteDataSource.clearTokens();
  }

  @override
  Future<bool> isLoggedIn() async {
    return _remoteDataSource.hasToken();
  }

  @override
  Future<String?> getAccessToken() async {
    return _remoteDataSource.getAccessToken();
  }

  @override
  Future<String?> getSavedRole() async {
    return _remoteDataSource.getSavedRole();
  }
}
