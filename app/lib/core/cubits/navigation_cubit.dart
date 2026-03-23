import 'package:flutter_bloc/flutter_bloc.dart';

/// Navigation state for bottom tab bar
class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0);

  void setTab(int index) => emit(index);
}
