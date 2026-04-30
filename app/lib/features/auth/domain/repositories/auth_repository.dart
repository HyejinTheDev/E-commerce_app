/// Abstract Auth Repository — Domain Layer
/// Defines the contract for auth operations, independent of data source.
abstract class AuthRepository {
  Future<Map<String, dynamic>> login(String email, String password);
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
  });
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<String?> getAccessToken();
  Future<String?> getSavedRole();
}
