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
