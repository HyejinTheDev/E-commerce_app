import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

class HomeLoaded extends HomeEvent {
  const HomeLoaded();
}

class HomeCategorySelected extends HomeEvent {
  final int index;
  const HomeCategorySelected(this.index);

  @override
  List<Object?> get props => [index];
}
