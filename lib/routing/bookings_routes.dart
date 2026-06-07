part of 'router.dart';

/// [BookingsScreen] routes
sealed class BookingsRoute extends KaiselRoute {
  const BookingsRoute();
}

final class BookingsRoot extends BookingsRoute {
  const BookingsRoot();

  @override
  bool operator ==(Object other) => identical(this, other) || other is BookingsRoot && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}
