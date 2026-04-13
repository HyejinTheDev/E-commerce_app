import '../../../../core/network/dio_client.dart';

class CategoryRemoteDataSource {
  final DioClient _client;
  CategoryRemoteDataSource(this._client);

  Future<List<dynamic>> getCategories() async {
    final response = await _client.dio.get('/categories');
    return response.data as List<dynamic>;
  }
}
