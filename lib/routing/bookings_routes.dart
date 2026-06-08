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

/// A single booking's detail page, addressed by its [bookingId]. Carries a
/// resolved [booking] when the caller has it (deep links pass id only).
final class BookingDetail extends BookingsRoute {
  const BookingDetail({required this.bookingId, this.booking});

  final String bookingId;
  final Booking? booking;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingDetail &&
          runtimeType == other.runtimeType &&
          bookingId == other.bookingId &&
          booking == other.booking;

  @override
  int get hashCode => Object.hash(bookingId, booking);
}
