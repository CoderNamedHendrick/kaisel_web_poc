part of 'router.dart';

/// [ProfileScreen] routes
sealed class ProfileRoute extends KaiselRoute {
  const ProfileRoute();
}

final class ProfileRoot extends ProfileRoute {
  const ProfileRoot();

  @override
  bool operator ==(Object other) => identical(this, other) || other is ProfileRoot && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// The account settings page, opened from the Profile tab.
final class ProfileSettings extends ProfileRoute {
  const ProfileSettings();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ProfileSettings && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// The edit-profile page, opened from the Profile tab.
final class ProfileEdit extends ProfileRoute {
  const ProfileEdit();

  @override
  bool operator ==(Object other) => identical(this, other) || other is ProfileEdit && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}
