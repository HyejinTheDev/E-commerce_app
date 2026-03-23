import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_bloc_types.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileState()) {
    on<ProfileLoaded>(_onLoaded);
    on<ProfilePreferenceToggled>(_onPreferenceToggled);
    on<ProfileSignedOut>(_onSignedOut);
  }

  void _onLoaded(ProfileLoaded event, Emitter<ProfileState> emit) {
    // Already set with defaults, but could make an API call here
    emit(const ProfileState());
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
