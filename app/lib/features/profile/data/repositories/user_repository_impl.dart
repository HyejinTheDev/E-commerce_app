import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;
  UserRepositoryImpl(this._remoteDataSource);

  @override
  Future<User> getProfile() async {
    final data = await _remoteDataSource.getProfile();
    return UserModel.fromJson(data);
  }

  @override
  Future<User> updateProfile(Map<String, dynamic> data) async {
    final result = await _remoteDataSource.updateProfile(data);
    return UserModel.fromJson(result);
  }

  @override
  Future<List<Map<String, dynamic>>> getAddresses() async {
    final data = await _remoteDataSource.getAddresses();
    return data.cast<Map<String, dynamic>>();
  }
}
