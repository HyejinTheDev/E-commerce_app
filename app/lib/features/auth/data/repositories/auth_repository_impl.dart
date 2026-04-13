import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Concrete implementation of [AuthRepository]
/// Bridges the domain layer to the data layer.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<void> login(String email, String password) async {
    final data = await _remoteDataSource.login(email, password);
    await _remoteDataSource.saveTokens(data);
  }

  @override
  Future<void> register({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    final data = await _remoteDataSource.register(
      email: email,
      password: password,
      name: name,
      phone: phone,
    );
    await _remoteDataSource.saveTokens(data);
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
}
