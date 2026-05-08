import '../entities/voucher.dart';
import '../repositories/voucher_repository.dart';
import 'package:injectable/injectable.dart';

/// Validate a voucher code — Domain UseCase
@injectable
class ValidateVoucherUseCase {
  final VoucherRepository _repository;

  ValidateVoucherUseCase(this._repository);

  Future<Voucher> call(String code) {
    return _repository.validateVoucher(code);
  }
}
