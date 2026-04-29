import '../entities/voucher.dart';
import '../repositories/voucher_repository.dart';

/// Validate a voucher code — Domain UseCase
class ValidateVoucherUseCase {
  final VoucherRepository _repository;

  ValidateVoucherUseCase(this._repository);

  Future<Voucher> call(String code) {
    return _repository.validateVoucher(code);
  }
}
