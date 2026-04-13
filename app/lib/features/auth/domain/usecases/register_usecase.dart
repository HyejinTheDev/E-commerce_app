import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class RegisterParams {
  final String email;
  final String password;
  final String name;
  final String? phone;
  const RegisterParams({
    required this.email,
    required this.password,
    required this.name,
    this.phone,
  });
}

class RegisterUseCase extends UseCase<void, RegisterParams> {
  final AuthRepository _repository;
  RegisterUseCase(this._repository);

  @override
  Future<void> call(RegisterParams params) {
    return _repository.register(
      email: params.email,
      password: params.password,
      name: params.name,
      phone: params.phone,
    );
  }
}
