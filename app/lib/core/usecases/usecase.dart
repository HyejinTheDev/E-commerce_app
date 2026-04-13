/// Base UseCase class for Clean Architecture
/// Every use case takes [Params] and returns [Future<T>]
abstract class UseCase<T, Params> {
  Future<T> call(Params params);
}

/// Use when a UseCase requires no parameters
class NoParams {
  const NoParams();
}
