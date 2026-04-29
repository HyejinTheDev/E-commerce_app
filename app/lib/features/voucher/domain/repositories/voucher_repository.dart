import '../entities/voucher.dart';

/// Abstract voucher repository — Domain Layer
abstract class VoucherRepository {
  /// Validate a voucher code, returns Voucher if valid, throws on error
  Future<Voucher> validateVoucher(String code);
}
