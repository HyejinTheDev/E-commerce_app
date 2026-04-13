import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetProfileUseCase extends UseCase<User, NoParams> {
  final UserRepository _repository;
  GetProfileUseCase(this._repository);

  @override
  Future<User> call(NoParams params) {
    return _repository.getProfile();
  }
}
