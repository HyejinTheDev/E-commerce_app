import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

class LoginParams {
  final String email;
  final String password;
  const LoginParams(this.email, this.password);
}

@injectable
class LoginUseCase extends UseCase<Map<String, dynamic>, LoginParams> {
  final AuthRepository _repository;
  LoginUseCase(this._repository);

  @override
  Future<Map<String, dynamic>> call(LoginParams params) {
    return _repository.login(params.email, params.password);
  }
}
