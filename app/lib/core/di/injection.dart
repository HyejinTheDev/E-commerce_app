import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Core
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  // Repositories
  // TODO: Register repositories

  // Use Cases
  // TODO: Register use cases
}
