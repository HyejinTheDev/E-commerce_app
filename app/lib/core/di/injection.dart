import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';

// ─── Auth ───
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/check_auth_usecase.dart';

// ─── Product ───
import '../../features/product/data/datasources/product_remote_datasource.dart';
import '../../features/product/data/repositories/product_repository_impl.dart';
import '../../features/product/domain/repositories/product_repository.dart';
import '../../features/product/domain/usecases/get_products_usecase.dart';
import '../../features/product/domain/usecases/get_product_by_id_usecase.dart';

// ─── Category ───
import '../../features/category/data/datasources/category_remote_datasource.dart';
import '../../features/category/data/repositories/category_repository_impl.dart';
import '../../features/category/domain/repositories/category_repository.dart';
import '../../features/category/domain/usecases/get_categories_usecase.dart';

// ─── Order ───
import '../../features/order/data/datasources/order_remote_datasource.dart';
import '../../features/order/data/repositories/order_repository_impl.dart';
import '../../features/order/domain/repositories/order_repository.dart';
import '../../features/order/domain/usecases/get_my_orders_usecase.dart';
import '../../features/order/domain/usecases/create_order_usecase.dart';

// ─── Profile ───
import '../../features/profile/data/datasources/user_remote_datasource.dart';
import '../../features/profile/data/repositories/user_repository_impl.dart';
import '../../features/profile/domain/repositories/user_repository.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';

// ─── Voucher ───
import '../../features/voucher/data/datasources/voucher_remote_datasource.dart';
import '../../features/voucher/data/repositories/voucher_repository_impl.dart';
import '../../features/voucher/domain/repositories/voucher_repository.dart';
import '../../features/voucher/domain/usecases/validate_voucher_usecase.dart';

// ─── Seller ───
import '../../features/seller/data/datasources/seller_remote_datasource.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // ─── Core ───
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  // ─── Auth ───
  getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(getIt<DioClient>()));
  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()));
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => CheckAuthUseCase(getIt<AuthRepository>()));

  // ─── Product ───
  getIt.registerLazySingleton<ProductRemoteDataSource>(
      () => ProductRemoteDataSource(getIt<DioClient>()));
  getIt.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(getIt<ProductRemoteDataSource>()));
  getIt.registerLazySingleton(() => GetProductsUseCase(getIt<ProductRepository>()));
  getIt.registerLazySingleton(() => GetProductByIdUseCase(getIt<ProductRepository>()));

  // ─── Category ───
  getIt.registerLazySingleton<CategoryRemoteDataSource>(
      () => CategoryRemoteDataSource(getIt<DioClient>()));
  getIt.registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl(getIt<CategoryRemoteDataSource>()));
  getIt.registerLazySingleton(() => GetCategoriesUseCase(getIt<CategoryRepository>()));

  // ─── Order ───
  getIt.registerLazySingleton<OrderRemoteDataSource>(
      () => OrderRemoteDataSource(getIt<DioClient>()));
  getIt.registerLazySingleton<OrderRepository>(
      () => OrderRepositoryImpl(getIt<OrderRemoteDataSource>()));
  getIt.registerLazySingleton(() => GetMyOrdersUseCase(getIt<OrderRepository>()));
  getIt.registerLazySingleton(() => CreateOrderUseCase(getIt<OrderRepository>()));

  // ─── Profile ───
  getIt.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSource(getIt<DioClient>()));
  getIt.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(getIt<UserRemoteDataSource>()));
  getIt.registerLazySingleton(() => GetProfileUseCase(getIt<UserRepository>()));

  // ─── Voucher ───
  getIt.registerLazySingleton<VoucherRemoteDataSource>(
      () => VoucherRemoteDataSource(getIt<DioClient>()));
  getIt.registerLazySingleton<VoucherRepository>(
      () => VoucherRepositoryImpl(getIt<VoucherRemoteDataSource>()));
  getIt.registerLazySingleton(() => ValidateVoucherUseCase(getIt<VoucherRepository>()));

  // ─── Seller ───
  getIt.registerLazySingleton<SellerRemoteDataSource>(
      () => SellerRemoteDataSource(getIt<DioClient>()));
}
