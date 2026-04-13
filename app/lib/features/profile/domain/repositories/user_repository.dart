import '../entities/user.dart';

/// Abstract User Repository — Domain Layer
abstract class UserRepository {
  Future<User> getProfile();
  Future<User> updateProfile(Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> getAddresses();
}
