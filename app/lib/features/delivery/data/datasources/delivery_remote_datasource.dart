import 'package:dio/dio.dart';
import '../../../../../core/network/dio_client.dart';

class DeliveryRemoteDataSource {
  final DioClient _client;

  DeliveryRemoteDataSource(this._client);

  Future<Map<String, dynamic>> getDashboard() async {
    final response = await _client.dio.get('/delivery/dashboard');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getStatus() async {
    final response = await _client.dio.get('/delivery/status');
    return response.data as Map<String, dynamic>;
  }

  Future<List<dynamic>> getShipments() async {
    final response = await _client.dio.get('/delivery/shipments');
    return response.data as List<dynamic>;
  }

  Future<List<dynamic>> getHistory() async {
    final response = await _client.dio.get('/delivery/history');
    return response.data as List<dynamic>;
  }

  Future<Map<String, dynamic>> updateShipmentStatus(String id, String status) async {
    final response = await _client.dio.patch('/delivery/shipments/$id/status', data: {'status': status});
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> toggleAvailability(bool isAvailable) async {
    final response = await _client.dio.patch('/delivery/availability', data: {'isAvailable': isAvailable});
    return response.data as Map<String, dynamic>;
  }
}
