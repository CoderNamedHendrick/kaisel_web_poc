part of 'router.dart';

/// [FavoritesScreen] routes
sealed class FavoriteRoute extends KaiselRoute {
  const FavoriteRoute();
}

final class FavoritesRoot extends FavoriteRoute {
  const FavoritesRoot();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoritesRoot && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}
