import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../repositories/product_repository.dart';
import '../repositories/category_repository.dart';
import '../repositories/order_repository.dart';
import '../repositories/user_repository.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Core
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  // Repositories
  getIt.registerLazySingleton<ProductRepository>(
      () => ProductRepository(getIt<DioClient>()));
  getIt.registerLazySingleton<CategoryRepository>(
      () => CategoryRepository(getIt<DioClient>()));
  getIt.registerLazySingleton<OrderRepository>(
      () => OrderRepository(getIt<DioClient>()));
  getIt.registerLazySingleton<UserRepository>(
      () => UserRepository(getIt<DioClient>()));
}
