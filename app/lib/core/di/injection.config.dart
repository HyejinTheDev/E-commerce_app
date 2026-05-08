// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/check_auth_usecase.dart' as _i831;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/domain/usecases/logout_usecase.dart' as _i48;
import '../../features/auth/domain/usecases/register_usecase.dart' as _i941;
import '../../features/category/data/datasources/category_remote_datasource.dart'
    as _i88;
import '../../features/category/data/repositories/category_repository_impl.dart'
    as _i528;
import '../../features/category/domain/repositories/category_repository.dart'
    as _i869;
import '../../features/category/domain/usecases/get_categories_usecase.dart'
    as _i125;
import '../../features/customer/search/domain/repositories/search_history_repository.dart'
    as _i277;
import '../../features/order/data/datasources/order_remote_datasource.dart'
    as _i773;
import '../../features/order/data/repositories/order_repository_impl.dart'
    as _i103;
import '../../features/order/domain/repositories/order_repository.dart'
    as _i765;
import '../../features/order/domain/usecases/create_order_usecase.dart'
    as _i291;
import '../../features/order/domain/usecases/get_my_orders_usecase.dart'
    as _i711;
import '../../features/product/data/datasources/product_remote_datasource.dart'
    as _i963;
import '../../features/product/data/repositories/product_repository_impl.dart'
    as _i1040;
import '../../features/product/domain/repositories/product_repository.dart'
    as _i39;
import '../../features/product/domain/usecases/get_product_by_id_usecase.dart'
    as _i534;
import '../../features/product/domain/usecases/get_products_usecase.dart'
    as _i1035;
import '../../features/profile/data/datasources/user_remote_datasource.dart'
    as _i680;
import '../../features/profile/data/repositories/user_repository_impl.dart'
    as _i938;
import '../../features/profile/domain/repositories/user_repository.dart'
    as _i146;
import '../../features/profile/domain/usecases/get_profile_usecase.dart'
    as _i965;
import '../../features/seller/data/datasources/seller_remote_datasource.dart'
    as _i410;
import '../../features/voucher/data/datasources/voucher_remote_datasource.dart'
    as _i257;
import '../../features/voucher/data/repositories/voucher_repository_impl.dart'
    as _i270;
import '../../features/voucher/domain/repositories/voucher_repository.dart'
    as _i1027;
import '../../features/voucher/domain/usecases/validate_voucher_usecase.dart'
    as _i444;
import '../network/dio_client.dart' as _i667;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i667.DioClient>(() => registerModule.dioClient);
    gh.lazySingleton<_i277.SearchHistoryRepository>(
        () => _i277.SearchHistoryRepositoryImpl());
    gh.lazySingleton<_i161.AuthRemoteDataSource>(
        () => _i161.AuthRemoteDataSource(gh<_i667.DioClient>()));
    gh.lazySingleton<_i88.CategoryRemoteDataSource>(
        () => _i88.CategoryRemoteDataSource(gh<_i667.DioClient>()));
    gh.lazySingleton<_i773.OrderRemoteDataSource>(
        () => _i773.OrderRemoteDataSource(gh<_i667.DioClient>()));
    gh.lazySingleton<_i963.ProductRemoteDataSource>(
        () => _i963.ProductRemoteDataSource(gh<_i667.DioClient>()));
    gh.lazySingleton<_i680.UserRemoteDataSource>(
        () => _i680.UserRemoteDataSource(gh<_i667.DioClient>()));
    gh.lazySingleton<_i410.SellerRemoteDataSource>(
        () => _i410.SellerRemoteDataSource(gh<_i667.DioClient>()));
    gh.lazySingleton<_i257.VoucherRemoteDataSource>(
        () => _i257.VoucherRemoteDataSource(gh<_i667.DioClient>()));
    gh.lazySingleton<_i765.OrderRepository>(
        () => _i103.OrderRepositoryImpl(gh<_i773.OrderRemoteDataSource>()));
    gh.lazySingleton<_i869.CategoryRepository>(() =>
        _i528.CategoryRepositoryImpl(gh<_i88.CategoryRemoteDataSource>()));
    gh.lazySingleton<_i1027.VoucherRepository>(
        () => _i270.VoucherRepositoryImpl(gh<_i257.VoucherRemoteDataSource>()));
    gh.lazySingleton<_i146.UserRepository>(
        () => _i938.UserRepositoryImpl(gh<_i680.UserRemoteDataSource>()));
    gh.lazySingleton<_i787.AuthRepository>(
        () => _i153.AuthRepositoryImpl(gh<_i161.AuthRemoteDataSource>()));
    gh.factory<_i444.ValidateVoucherUseCase>(
        () => _i444.ValidateVoucherUseCase(gh<_i1027.VoucherRepository>()));
    gh.factory<_i965.GetProfileUseCase>(
        () => _i965.GetProfileUseCase(gh<_i146.UserRepository>()));
    gh.lazySingleton<_i39.ProductRepository>(() =>
        _i1040.ProductRepositoryImpl(gh<_i963.ProductRemoteDataSource>()));
    gh.factory<_i125.GetCategoriesUseCase>(
        () => _i125.GetCategoriesUseCase(gh<_i869.CategoryRepository>()));
    gh.factory<_i291.CreateOrderUseCase>(
        () => _i291.CreateOrderUseCase(gh<_i765.OrderRepository>()));
    gh.factory<_i711.GetMyOrdersUseCase>(
        () => _i711.GetMyOrdersUseCase(gh<_i765.OrderRepository>()));
    gh.factory<_i831.CheckAuthUseCase>(
        () => _i831.CheckAuthUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i188.LoginUseCase>(
        () => _i188.LoginUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i48.LogoutUseCase>(
        () => _i48.LogoutUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i941.RegisterUseCase>(
        () => _i941.RegisterUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i1035.GetProductsUseCase>(
        () => _i1035.GetProductsUseCase(gh<_i39.ProductRepository>()));
    gh.factory<_i534.GetProductByIdUseCase>(
        () => _i534.GetProductByIdUseCase(gh<_i39.ProductRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
