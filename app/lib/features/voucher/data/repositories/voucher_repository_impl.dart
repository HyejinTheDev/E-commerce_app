import 'package:dio/dio.dart';
import '../../domain/entities/voucher.dart';
import '../../domain/repositories/voucher_repository.dart';
import '../datasources/voucher_remote_datasource.dart';
import '../models/voucher_model.dart';

/// Voucher repository implementation — Data Layer
class VoucherRepositoryImpl implements VoucherRepository {
  final VoucherRemoteDataSource _remoteDataSource;

  VoucherRepositoryImpl(this._remoteDataSource);

  @override
  Future<Voucher> validateVoucher(String code) async {
    try {
      final json = await _remoteDataSource.validateVoucher(code);
      return VoucherModel.fromJson(json);
    } on DioException catch (e) {
      final message = e.response?.data?['message'] as String?;
      throw Exception(message ?? 'Mã không hợp lệ');
    }
  }
}
