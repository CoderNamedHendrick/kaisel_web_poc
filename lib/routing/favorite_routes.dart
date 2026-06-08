part of 'router.dart';

/// [FavoritesScreen] routes
sealed class FavoriteRoute extends KaiselRoute {
  const FavoriteRoute();
}

final class FavoritesRoot extends FavoriteRoute {
  const FavoritesRoot();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FavoritesRoot && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// A saved court's detail page, opened from the Favorites tab. Carries a
/// resolved [court] when available, or just a [courtId] (deep links).
final class FavoriteCourtDetail extends FavoriteRoute {
  const FavoriteCourtDetail({required this.courtId, this.court});

  final String courtId;
  final Court? court;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteCourtDetail &&
          runtimeType == other.runtimeType &&
          courtId == other.courtId &&
          court == other.court;

  @override
  int get hashCode => Object.hash(courtId, court);
}

/// A saved coach or partner's profile, opened from the Favorites tab. Like
/// [HomeUserProfile] it takes a resolved [player] when available, otherwise a
/// [userId] to fetch by.
final class FavoriteUserProfile extends FavoriteRoute {
  const FavoriteUserProfile({required this.userId, this.player});

  final String userId;
  final Player? player;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteUserProfile &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          player == other.player;

  @override
  int get hashCode => Object.hash(userId, player);
}
