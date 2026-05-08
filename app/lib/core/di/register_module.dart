import 'package:injectable/injectable.dart';
import 'package:ecommerce_app/core/network/dio_client.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  DioClient get dioClient => DioClient();
}
