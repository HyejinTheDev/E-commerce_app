/// Abstract Auth Repository — Domain Layer
/// Defines the contract for auth operations, independent of data source.
abstract class AuthRepository {
  Future<void> login(String email, String password);
  Future<void> register({
    required String email,
    required String password,
    required String name,
    String? phone,
  });
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<String?> getAccessToken();
}
