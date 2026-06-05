part of 'router.dart';

/// [FavoritesScreen] routes
sealed class FavoriteRoute extends KaiselRoute {
  const FavoriteRoute();
}

final class FavoritesRoot extends FavoriteRoute {
  const FavoritesRoot();
}
