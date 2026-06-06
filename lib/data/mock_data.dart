import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// Mock data layer for the RallyUp P2P tennis / racket-sports community POC.
///
/// Everything here is fake, deterministic and offline-safe (no network images)
/// so the screens render identically every run. Avatars are rendered from
/// initials + a seeded colour; "photos" are gradient blocks.
/// ---------------------------------------------------------------------------

enum CourtSurface { hard, clay, grass, indoor }

extension CourtSurfaceX on CourtSurface {
  String get label => switch (this) {
        CourtSurface.hard => 'Hard',
        CourtSurface.clay => 'Clay',
        CourtSurface.grass => 'Grass',
        CourtSurface.indoor => 'Indoor',
      };

  IconData get icon => switch (this) {
        CourtSurface.hard => Icons.grid_4x4,
        CourtSurface.clay => Icons.terrain,
        CourtSurface.grass => Icons.grass,
        CourtSurface.indoor => Icons.home_work_outlined,
      };
}

enum BookingStatus { upcoming, completed, cancelled }

extension BookingStatusX on BookingStatus {
  String get label => switch (this) {
        BookingStatus.upcoming => 'Upcoming',
        BookingStatus.completed => 'Completed',
        BookingStatus.cancelled => 'Cancelled',
      };

  Color color(ColorScheme s) => switch (this) {
        BookingStatus.upcoming => s.primary,
        BookingStatus.completed => Colors.green.shade600,
        BookingStatus.cancelled => s.error,
      };
}

enum SessionKind { match, lesson, courtRental, doubles }

extension SessionKindX on SessionKind {
  String get label => switch (this) {
        SessionKind.match => 'Singles match',
        SessionKind.lesson => 'Coaching lesson',
        SessionKind.courtRental => 'Court rental',
        SessionKind.doubles => 'Doubles match',
      };

  IconData get icon => switch (this) {
        SessionKind.match => Icons.sports_tennis,
        SessionKind.lesson => Icons.school_outlined,
        SessionKind.courtRental => Icons.stadium_outlined,
        SessionKind.doubles => Icons.groups_outlined,
      };
}

enum TestStatus { available, scheduled, passed }

/// A person on the platform — a hitting partner, opponent or coach.
class Player {
  const Player({
    required this.name,
    required this.ntrp,
    required this.location,
    required this.color,
    this.isCoach = false,
    this.isOnline = false,
    this.winRate,
    this.bio,
  });

  final String name;
  final double ntrp; // NTRP skill rating, 1.0 – 7.0
  final String location;
  final Color color;
  final bool isCoach;
  final bool isOnline;
  final int? winRate; // percentage
  final String? bio;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first).toUpperCase();
  }
}

class Court {
  const Court({
    required this.name,
    required this.surface,
    required this.location,
    required this.pricePerHour,
    required this.rating,
    required this.distanceKm,
    required this.gradient,
    this.courts = 1,
    this.lit = false,
  });

  final String name;
  final CourtSurface surface;
  final String location;
  final int pricePerHour;
  final double rating;
  final double distanceKm;
  final List<Color> gradient;
  final int courts;
  final bool lit;
}

class OpenSession {
  const OpenSession({
    required this.kind,
    required this.host,
    required this.court,
    required this.when,
    required this.spotsLeft,
    required this.skillRange,
  });

  final SessionKind kind;
  final Player host;
  final String court;
  final String when;
  final int spotsLeft;
  final String skillRange;
}

class Booking {
  const Booking({
    required this.kind,
    required this.court,
    required this.location,
    required this.dateLabel,
    required this.timeLabel,
    required this.status,
    required this.withPlayer,
    required this.price,
  });

  final SessionKind kind;
  final String court;
  final String location;
  final String dateLabel;
  final String timeLabel;
  final BookingStatus status;
  final Player withPlayer;
  final int price;
}

class Chat {
  const Chat({
    required this.player,
    required this.lastMessage,
    required this.time,
    this.unread = 0,
    this.sentByMe = false,
  });

  final Player player;
  final String lastMessage;
  final String time;
  final int unread;
  final bool sentByMe;
}

class SkillTest {
  const SkillTest({
    required this.title,
    required this.description,
    required this.level,
    required this.durationMin,
    required this.status,
    this.score,
    this.scheduledWith,
  });

  final String title;
  final String description;
  final String level;
  final int durationMin;
  final TestStatus status;
  final int? score; // 0 – 100 when passed
  final Player? scheduledWith;
}

class Achievement {
  const Achievement(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}

/// ---------------------------------------------------------------------------
/// Seed data
/// ---------------------------------------------------------------------------

class MockData {
  MockData._();

  static const me = Player(
    name: 'Alex Rivera',
    ntrp: 4.0,
    location: 'Brooklyn, NY',
    color: Color(0xFF2E7D32),
    isOnline: true,
    winRate: 62,
    bio: 'Weekend warrior chasing a 4.5 rating. Aggressive baseliner, loves a long rally.',
  );

  static const players = <Player>[
    Player(
      name: 'Maya Chen',
      ntrp: 4.5,
      location: 'Williamsburg · 1.2 km',
      color: Color(0xFF6A1B9A),
      isOnline: true,
      winRate: 71,
      bio: 'Lefty with a wicked slice.',
    ),
    Player(
      name: 'Diego Santos',
      ntrp: 3.5,
      location: 'Bushwick · 2.8 km',
      color: Color(0xFF1565C0),
      winRate: 54,
      bio: 'Just getting back into the game.',
    ),
    Player(
      name: 'Priya Nair',
      ntrp: 4.0,
      location: 'DUMBO · 0.9 km',
      color: Color(0xFFAD1457),
      isOnline: true,
      winRate: 65,
    ),
    Player(
      name: 'Tom Becker',
      ntrp: 5.0,
      location: 'Park Slope · 3.4 km',
      color: Color(0xFFE65100),
      winRate: 78,
      bio: 'Former college player. Hit hard or go home.',
    ),
    Player(
      name: 'Sofia Rossi',
      ntrp: 3.0,
      location: 'Greenpoint · 1.7 km',
      color: Color(0xFF00838F),
      isOnline: true,
      winRate: 48,
    ),
    Player(
      name: 'Jamal Wright',
      ntrp: 4.5,
      location: 'Fort Greene · 2.1 km',
      color: Color(0xFF4527A0),
      winRate: 69,
    ),
  ];

  static const coaches = <Player>[
    Player(
      name: 'Coach Lena Park',
      ntrp: 6.5,
      location: 'Prospect Park Tennis Center',
      color: Color(0xFFC62828),
      isCoach: true,
      isOnline: true,
      winRate: 91,
      bio: 'USPTA certified. 12 years coaching juniors and adults.',
    ),
    Player(
      name: 'Coach Marcus Hale',
      ntrp: 6.0,
      location: 'McCarren Courts',
      color: Color(0xFF283593),
      isCoach: true,
      winRate: 88,
      bio: 'Specialises in serve mechanics and footwork.',
    ),
  ];

  static const courts = <Court>[
    Court(
      name: 'Prospect Park Tennis Center',
      surface: CourtSurface.hard,
      location: 'Prospect Park · 1.5 km',
      pricePerHour: 32,
      rating: 4.8,
      distanceKm: 1.5,
      courts: 11,
      lit: true,
      gradient: [Color(0xFF1B5E20), Color(0xFF66BB6A)],
    ),
    Court(
      name: 'McCarren Park Courts',
      surface: CourtSurface.hard,
      location: 'Greenpoint · 1.7 km',
      pricePerHour: 24,
      rating: 4.5,
      distanceKm: 1.7,
      courts: 7,
      lit: true,
      gradient: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
    ),
    Court(
      name: 'Red Hook Clay Club',
      surface: CourtSurface.clay,
      location: 'Red Hook · 4.2 km',
      pricePerHour: 45,
      rating: 4.9,
      distanceKm: 4.2,
      courts: 4,
      gradient: [Color(0xFFBF360C), Color(0xFFFF8A65)],
    ),
    Court(
      name: 'Brooklyn Bridge Indoor',
      surface: CourtSurface.indoor,
      location: 'DUMBO · 0.8 km',
      pricePerHour: 58,
      rating: 4.7,
      distanceKm: 0.8,
      courts: 6,
      lit: true,
      gradient: [Color(0xFF4A148C), Color(0xFFBA68C8)],
    ),
    Court(
      name: 'Fort Greene Grass Lawn',
      surface: CourtSurface.grass,
      location: 'Fort Greene · 2.0 km',
      pricePerHour: 40,
      rating: 4.6,
      distanceKm: 2.0,
      courts: 2,
      gradient: [Color(0xFF004D40), Color(0xFF4DB6AC)],
    ),
  ];

  static List<OpenSession> get openSessions => [
        OpenSession(
          kind: SessionKind.doubles,
          host: players[0],
          court: 'McCarren Park Courts',
          when: 'Today · 6:30 PM',
          spotsLeft: 1,
          skillRange: 'NTRP 4.0–4.5',
        ),
        OpenSession(
          kind: SessionKind.match,
          host: players[3],
          court: 'Prospect Park Tennis Center',
          when: 'Tomorrow · 7:00 AM',
          spotsLeft: 1,
          skillRange: 'NTRP 4.5+',
        ),
        OpenSession(
          kind: SessionKind.match,
          host: players[4],
          court: 'Brooklyn Bridge Indoor',
          when: 'Sat · 10:00 AM',
          spotsLeft: 1,
          skillRange: 'NTRP 3.0–3.5',
        ),
      ];

  static List<Booking> get bookings => [
        Booking(
          kind: SessionKind.match,
          court: 'Prospect Park Tennis Center',
          location: 'Court 6 · Hard',
          dateLabel: 'Fri, Jun 6',
          timeLabel: '6:30 – 8:00 PM',
          status: BookingStatus.upcoming,
          withPlayer: players[0],
          price: 32,
        ),
        Booking(
          kind: SessionKind.lesson,
          court: 'Prospect Park Tennis Center',
          location: 'Court 2 · with Coach Lena',
          dateLabel: 'Sun, Jun 8',
          timeLabel: '9:00 – 10:00 AM',
          status: BookingStatus.upcoming,
          withPlayer: coaches[0],
          price: 75,
        ),
        Booking(
          kind: SessionKind.doubles,
          court: 'McCarren Park Courts',
          location: 'Court 3 · Hard',
          dateLabel: 'Wed, Jun 11',
          timeLabel: '7:00 – 8:30 PM',
          status: BookingStatus.upcoming,
          withPlayer: players[5],
          price: 24,
        ),
        Booking(
          kind: SessionKind.match,
          court: 'Red Hook Clay Club',
          location: 'Court 1 · Clay',
          dateLabel: 'Sun, Jun 1',
          timeLabel: '8:00 – 9:30 AM',
          status: BookingStatus.completed,
          withPlayer: players[2],
          price: 45,
        ),
        Booking(
          kind: SessionKind.courtRental,
          court: 'Brooklyn Bridge Indoor',
          location: 'Court 4 · Indoor',
          dateLabel: 'Thu, May 29',
          timeLabel: '6:00 – 7:00 PM',
          status: BookingStatus.completed,
          withPlayer: players[1],
          price: 58,
        ),
        Booking(
          kind: SessionKind.match,
          court: 'Fort Greene Grass Lawn',
          location: 'Court 2 · Grass',
          dateLabel: 'Sat, May 24',
          timeLabel: '11:00 AM – 12:30 PM',
          status: BookingStatus.cancelled,
          withPlayer: players[3],
          price: 40,
        ),
      ];

  static List<Chat> get chats => [
        Chat(
          player: players[0],
          lastMessage: 'See you at McCarren at 6:30, bring the new balls!',
          time: '2m',
          unread: 2,
        ),
        Chat(
          player: coaches[0],
          lastMessage: 'Great progress on your serve today 🎾',
          time: '1h',
          unread: 1,
        ),
        Chat(
          player: players[3],
          lastMessage: 'You: Rematch Sunday morning?',
          time: '3h',
          sentByMe: true,
        ),
        Chat(
          player: players[2],
          lastMessage: 'That was a brutal tiebreak 😅 gg',
          time: 'Yesterday',
        ),
        Chat(
          player: players[5],
          lastMessage: 'You: I can cover the court fee this time',
          time: 'Mon',
          sentByMe: true,
        ),
        Chat(
          player: players[1],
          lastMessage: 'Are you in the 4.0 ladder this season?',
          time: 'Sun',
        ),
      ];

  static List<SkillTest> get skillTests => [
        SkillTest(
          title: 'NTRP Rating Assessment',
          description: 'A certified rally + match-play evaluation to set your official skill rating.',
          level: 'All levels',
          durationMin: 60,
          status: TestStatus.scheduled,
          scheduledWith: coaches[0],
        ),
        const SkillTest(
          title: 'Serve Consistency Test',
          description: 'Land 20 first serves in the box. Tracks speed, placement and fault rate.',
          level: 'Intermediate',
          durationMin: 20,
          status: TestStatus.passed,
          score: 84,
        ),
        const SkillTest(
          title: 'Baseline Rally Drill',
          description: 'Maintain a cross-court rally for 30+ shots without an unforced error.',
          level: 'Intermediate',
          durationMin: 25,
          status: TestStatus.passed,
          score: 76,
        ),
        const SkillTest(
          title: 'Volley & Net Play',
          description: 'Reaction volleys and approach-shot footwork assessment.',
          level: 'Advanced',
          durationMin: 30,
          status: TestStatus.available,
        ),
        const SkillTest(
          title: 'Match IQ Quiz',
          description: 'Situational tactics, scoring rules and shot-selection scenarios.',
          level: 'All levels',
          durationMin: 15,
          status: TestStatus.available,
        ),
      ];

  static const achievements = <Achievement>[
    Achievement('50 Matches', Icons.emoji_events, Color(0xFFF9A825)),
    Achievement('Serve Ace', Icons.bolt, Color(0xFF1565C0)),
    Achievement('Clay Specialist', Icons.terrain, Color(0xFFBF360C)),
    Achievement('5-Win Streak', Icons.local_fire_department, Color(0xFFD84315)),
    Achievement('Early Bird', Icons.wb_sunny, Color(0xFFF9A825)),
  ];
}
