import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/login_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = LoginUseCase(mockAuthRepository);
  });

  group('LoginUseCase', () {
    final tEmail = 'test@example.com';
    final tPassword = 'password123';

    test('should call login on the repository with correct credentials', () async {
      // arrange
      when(() => mockAuthRepository.login(any(), any()))
          .thenAnswer((_) async => {});

      // act
      await usecase(LoginParams(tEmail, tPassword));

      // assert
      verify(() => mockAuthRepository.login(tEmail, tPassword)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should throw an exception when repository throws', () async {
      // arrange
      when(() => mockAuthRepository.login(any(), any()))
          .thenThrow(Exception('Login Failed'));

      // act & assert
      expect(() => usecase(LoginParams(tEmail, tPassword)), throwsA(isA<Exception>()));
    });
  });
}
