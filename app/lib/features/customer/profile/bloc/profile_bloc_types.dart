import 'package:equatable/equatable.dart';

// ─── Events ───
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => [];
}

class ProfileLoaded extends ProfileEvent {
  const ProfileLoaded();
}

class ProfilePreferenceToggled extends ProfileEvent {
  final String key;
  final bool value;
  const ProfilePreferenceToggled(this.key, this.value);
  @override
  List<Object?> get props => [key, value];
}

class ProfileSignedOut extends ProfileEvent {
  const ProfileSignedOut();
}

// ─── State ───
class ProfileState extends Equatable {
  final String name;
  final String email;
  final int orderCount;
  final int addressCount;
  final bool darkMode;
  final bool pushNotifications;
  final bool emailUpdates;
  final bool isSignedOut;

  const ProfileState({
    this.name = 'Sarah Johnson',
    this.email = 'sarah.j@email.com',
    this.orderCount = 12,
    this.addressCount = 2,
    this.darkMode = false,
    this.pushNotifications = true,
    this.emailUpdates = true,
    this.isSignedOut = false,
  });

  ProfileState copyWith({
    bool? darkMode,
    bool? pushNotifications,
    bool? emailUpdates,
    bool? isSignedOut,
  }) {
    return ProfileState(
      name: name,
      email: email,
      orderCount: orderCount,
      addressCount: addressCount,
      darkMode: darkMode ?? this.darkMode,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailUpdates: emailUpdates ?? this.emailUpdates,
      isSignedOut: isSignedOut ?? this.isSignedOut,
    );
  }

  @override
  List<Object?> get props => [
        name, email, orderCount, addressCount,
        darkMode, pushNotifications, emailUpdates, isSignedOut,
      ];
}
