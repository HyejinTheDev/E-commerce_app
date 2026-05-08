import '../../../../core/network/dio_client.dart';
import 'package:injectable/injectable.dart';

/// Voucher remote data source — calls POST /vouchers/validate
@lazySingleton
class VoucherRemoteDataSource {
  final DioClient _client;

  VoucherRemoteDataSource(this._client);

  /// Returns raw JSON map if valid, throws DioException on error
  Future<Map<String, dynamic>> validateVoucher(String code) async {
    final response = await _client.dio.post(
      '/vouchers/validate',
      data: {'code': code},
    );
    return response.data as Map<String, dynamic>;
  }
}
