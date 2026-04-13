import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class CheckAuthUseCase extends UseCase<bool, NoParams> {
  final AuthRepository _repository;
  CheckAuthUseCase(this._repository);

  @override
  Future<bool> call(NoParams params) {
    return _repository.isLoggedIn();
  }
}
