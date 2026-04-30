import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class RegisterParams {
  final String email;
  final String password;
  final String name;
  final String? phone;
  final String role;
  final String? shopName;
  final String? shopDescription;
  final String? vehicleType;
  final String? licensePlate;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.name,
    this.phone,
    this.role = 'CUSTOMER',
    this.shopName,
    this.shopDescription,
    this.vehicleType,
    this.licensePlate,
  });
}

class RegisterUseCase extends UseCase<Map<String, dynamic>, RegisterParams> {
  final AuthRepository _repository;
  RegisterUseCase(this._repository);

  @override
  Future<Map<String, dynamic>> call(RegisterParams params) {
    return _repository.register(
      email: params.email,
      password: params.password,
      name: params.name,
      phone: params.phone,
      role: params.role,
      shopName: params.shopName,
      shopDescription: params.shopDescription,
      vehicleType: params.vehicleType,
      licensePlate: params.licensePlate,
    );
  }
}
