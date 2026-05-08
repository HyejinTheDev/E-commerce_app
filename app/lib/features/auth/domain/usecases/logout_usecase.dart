import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class LogoutUseCase extends UseCase<void, NoParams> {
  final AuthRepository _repository;
  LogoutUseCase(this._repository);

  @override
  Future<void> call(NoParams params) {
    return _repository.logout();
  }
}
