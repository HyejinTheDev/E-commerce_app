import '../../../../core/network/dio_client.dart';

class UserRemoteDataSource {
  final DioClient _client;
  UserRemoteDataSource(this._client);

  Future<Map<String, dynamic>> getProfile() async {
    final response = await _client.dio.get('/users/profile');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final response = await _client.dio.patch('/users/profile', data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<List<dynamic>> getAddresses() async {
    final response = await _client.dio.get('/users/addresses');
    return response.data as List<dynamic>;
  }
}
