import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../profile/domain/repositories/user_repository.dart';
import '../../../../main.dart' show themeNotifier;
import 'profile_bloc_types.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;

  ProfileBloc(this._userRepository) : super(const ProfileState()) {
    on<ProfileLoaded>(_onLoaded);
    on<ProfilePreferenceToggled>(_onPreferenceToggled);
    on<ProfileSignedOut>(_onSignedOut);
  }

  Future<void> _onLoaded(
      ProfileLoaded event, Emitter<ProfileState> emit) async {
    try {
      final user = await _userRepository.getProfile();
      emit(ProfileState(
        name: user.name,
        email: user.email,
        orderCount: user.orderCount,
        addressCount: user.addressCount,
        darkMode: themeNotifier.isDarkMode,
      ));
    } catch (e) {
      // If not authenticated, show defaults
      emit(const ProfileState());
    }
  }

  void _onPreferenceToggled(
      ProfilePreferenceToggled event, Emitter<ProfileState> emit) {
    switch (event.key) {
      case 'darkMode':
        emit(state.copyWith(darkMode: event.value));
        break;
      case 'pushNotifications':
        emit(state.copyWith(pushNotifications: event.value));
        break;
      case 'emailUpdates':
        emit(state.copyWith(emailUpdates: event.value));
        break;
    }
  }

  void _onSignedOut(ProfileSignedOut event, Emitter<ProfileState> emit) {
    emit(state.copyWith(isSignedOut: true));
  }
}
