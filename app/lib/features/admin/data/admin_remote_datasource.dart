import '../../../../core/network/dio_client.dart';

class AdminRemoteDataSource {
  final DioClient _client;

  AdminRemoteDataSource(this._client);

  Future<Map<String, dynamic>> getStats() async {
    final response = await _client.dio.get('/admin/stats');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getUsers({String? role, int page = 1}) async {
    final params = <String, dynamic>{'page': page, 'limit': 20};
    if (role != null) params['role'] = role;
    final response = await _client.dio.get('/admin/users', queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<List<dynamic>> getAllShops() async {
    final response = await _client.dio.get('/admin/shops');
    return response.data as List<dynamic>;
  }

  Future<List<dynamic>> getPendingShops() async {
    final response = await _client.dio.get('/admin/shops/pending');
    return response.data as List<dynamic>;
  }

  Future<Map<String, dynamic>> approveShop(String shopId, String status) async {
    final response = await _client.dio.patch('/admin/shops/$shopId/approve', data: {'status': status});
    return response.data as Map<String, dynamic>;
  }

  Future<List<dynamic>> getAllDrivers() async {
    final response = await _client.dio.get('/admin/drivers');
    return response.data as List<dynamic>;
  }

  Future<Map<String, dynamic>> toggleDriverAvailability(String driverId, bool isAvailable) async {
    final response = await _client.dio.patch('/admin/drivers/$driverId/availability', data: {'isAvailable': isAvailable});
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateUserRole(String userId, String role) async {
    final response = await _client.dio.patch('/admin/users/$userId/role', data: {'role': role});
    return response.data as Map<String, dynamic>;
  }
}
