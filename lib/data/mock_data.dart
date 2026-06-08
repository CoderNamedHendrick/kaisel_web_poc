import 'dart:convert';

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

/// ---------------------------------------------------------------------------
/// Mock data layer for the RallyUp P2P tennis / racket-sports community POC.
///
/// The seed data lives in JSON files under `assets/mock/` and is parsed once at
/// startup via [MockData.load]. Everything stays fake, deterministic and
/// offline-safe (no network images) so the screens render identically every
/// run. Avatars are rendered from initials + a seeded colour; "photos" are
/// gradient blocks.
///
/// Colours are stored as 8-digit ARGB hex strings (e.g. `"FF2E7D32"`) and
/// icons as short keys mapped to const [IconData] in [_achievementIcons] —
/// JSON can't carry Dart `Color`/`IconData` directly, and keeping the icons
/// const preserves Flutter's icon tree-shaking.
/// ---------------------------------------------------------------------------

/// Parse an 8-digit ARGB hex string (no `0x`/`#` prefix) into a [Color].
Color _hexColor(String hex) => Color(int.parse(hex, radix: 16));

/// Maps achievement icon keys (as stored in JSON) to const [IconData].
const Map<String, IconData> _achievementIcons = {
  'trophy': Icons.emoji_events,
  'bolt': Icons.bolt,
  'terrain': Icons.terrain,
  'fire': Icons.local_fire_department,
  'sun': Icons.wb_sunny,
};

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
    required this.id,
    required this.name,
    required this.ntrp,
    required this.location,
    required this.color,
    this.isCoach = false,
    this.isOnline = false,
    this.winRate,
    this.bio,
  });

  factory Player.fromJson(Map<String, dynamic> json) => Player(
    id: json['id'] as String,
    name: json['name'] as String,
    ntrp: (json['ntrp'] as num).toDouble(),
    location: json['location'] as String,
    color: _hexColor(json['color'] as String),
    isCoach: json['isCoach'] as bool? ?? false,
    isOnline: json['isOnline'] as bool? ?? false,
    winRate: json['winRate'] as int?,
    bio: json['bio'] as String?,
  );

  final String id;
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Player &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          ntrp == other.ntrp &&
          location == other.location &&
          color == other.color &&
          isCoach == other.isCoach &&
          isOnline == other.isOnline &&
          winRate == other.winRate &&
          bio == other.bio;

  @override
  int get hashCode => Object.hash(id, name, ntrp, location, color, isCoach, isOnline, winRate, bio);
}

class Court {
  const Court({
    required this.id,
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

  factory Court.fromJson(Map<String, dynamic> json) => Court(
    id: json['id'] as String,
    name: json['name'] as String,
    surface: CourtSurface.values.byName(json['surface'] as String),
    location: json['location'] as String,
    pricePerHour: json['pricePerHour'] as int,
    rating: (json['rating'] as num).toDouble(),
    distanceKm: (json['distanceKm'] as num).toDouble(),
    gradient: [for (final c in json['gradient'] as List) _hexColor(c as String)],
    courts: json['courts'] as int? ?? 1,
    lit: json['lit'] as bool? ?? false,
  );

  final String id;
  final String name;
  final CourtSurface surface;
  final String location;
  final int pricePerHour;
  final double rating;
  final double distanceKm;
  final List<Color> gradient;
  final int courts;
  final bool lit;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Court &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          surface == other.surface &&
          location == other.location &&
          pricePerHour == other.pricePerHour &&
          rating == other.rating &&
          distanceKm == other.distanceKm &&
          listEquals(gradient, other.gradient) &&
          courts == other.courts &&
          lit == other.lit;

  @override
  int get hashCode =>
      Object.hash(id, name, surface, location, pricePerHour, rating, distanceKm, Object.hashAll(gradient), courts, lit);
}

class OpenSession {
  const OpenSession({
    required this.id,
    required this.kind,
    required this.host,
    required this.court,
    required this.when,
    required this.spotsLeft,
    required this.skillRange,
  });

  factory OpenSession.fromJson(Map<String, dynamic> json, PlayerResolver resolve) => OpenSession(
    id: json['id'] as String,
    kind: SessionKind.values.byName(json['kind'] as String),
    host: resolve(json['hostId'] as String),
    court: json['court'] as String,
    when: json['when'] as String,
    spotsLeft: json['spotsLeft'] as int,
    skillRange: json['skillRange'] as String,
  );

  final String id;
  final SessionKind kind;
  final Player host;
  final String court;
  final String when;
  final int spotsLeft;
  final String skillRange;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OpenSession &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          kind == other.kind &&
          host == other.host &&
          court == other.court &&
          when == other.when &&
          spotsLeft == other.spotsLeft &&
          skillRange == other.skillRange;

  @override
  int get hashCode => Object.hash(id, kind, host, court, when, spotsLeft, skillRange);
}

class Booking {
  const Booking({
    required this.id,
    required this.kind,
    required this.court,
    required this.location,
    required this.dateLabel,
    required this.timeLabel,
    required this.status,
    required this.withPlayer,
    required this.price,
  });

  factory Booking.fromJson(Map<String, dynamic> json, PlayerResolver resolve) => Booking(
    id: json['id'] as String,
    kind: SessionKind.values.byName(json['kind'] as String),
    court: json['court'] as String,
    location: json['location'] as String,
    dateLabel: json['dateLabel'] as String,
    timeLabel: json['timeLabel'] as String,
    status: BookingStatus.values.byName(json['status'] as String),
    withPlayer: resolve(json['withPlayerId'] as String),
    price: json['price'] as int,
  );

  final String id;
  final SessionKind kind;
  final String court;
  final String location;
  final String dateLabel;
  final String timeLabel;
  final BookingStatus status;
  final Player withPlayer;
  final int price;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Booking &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          kind == other.kind &&
          court == other.court &&
          location == other.location &&
          dateLabel == other.dateLabel &&
          timeLabel == other.timeLabel &&
          status == other.status &&
          withPlayer == other.withPlayer &&
          price == other.price;

  @override
  int get hashCode => Object.hash(id, kind, court, location, dateLabel, timeLabel, status, withPlayer, price);
}

/// A single message within a [Chat] conversation.
class Message {
  const Message({required this.text, required this.fromMe, required this.time});

  factory Message.fromJson(Map<String, dynamic> json) =>
      Message(text: json['text'] as String, fromMe: json['fromMe'] as bool, time: json['time'] as String);

  final String text;
  final bool fromMe;
  final String time;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          fromMe == other.fromMe &&
          time == other.time;

  @override
  int get hashCode => Object.hash(text, fromMe, time);
}

class Chat {
  const Chat({
    required this.id,
    required this.player,
    required this.lastMessage,
    required this.time,
    this.unread = 0,
    this.sentByMe = false,
    this.messages = const [],
  });

  factory Chat.fromJson(Map<String, dynamic> json, PlayerResolver resolve) => Chat(
    id: json['id'] as String,
    player: resolve(json['playerId'] as String),
    lastMessage: json['lastMessage'] as String,
    time: json['time'] as String,
    unread: json['unread'] as int? ?? 0,
    sentByMe: json['sentByMe'] as bool? ?? false,
    messages: [for (final m in (json['messages'] as List? ?? const [])) Message.fromJson(m as Map<String, dynamic>)],
  );

  final String id;
  final Player player;
  final String lastMessage;
  final String time;
  final int unread;
  final bool sentByMe;
  final List<Message> messages;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Chat &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          player == other.player &&
          lastMessage == other.lastMessage &&
          time == other.time &&
          unread == other.unread &&
          sentByMe == other.sentByMe &&
          listEquals(messages, other.messages);

  @override
  int get hashCode => Object.hash(id, player, lastMessage, time, unread, sentByMe, Object.hashAll(messages));
}

class SkillTest {
  const SkillTest({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.durationMin,
    required this.status,
    this.score,
    this.scheduledWith,
  });

  factory SkillTest.fromJson(Map<String, dynamic> json, PlayerResolver resolve) {
    final scheduledWithId = json['scheduledWithId'] as String?;
    return SkillTest(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      level: json['level'] as String,
      durationMin: json['durationMin'] as int,
      status: TestStatus.values.byName(json['status'] as String),
      score: json['score'] as int?,
      scheduledWith: scheduledWithId == null ? null : resolve(scheduledWithId),
    );
  }

  final String id;
  final String title;
  final String description;
  final String level;
  final int durationMin;
  final TestStatus status;
  final int? score; // 0 – 100 when passed
  final Player? scheduledWith;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkillTest &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          level == other.level &&
          durationMin == other.durationMin &&
          status == other.status &&
          score == other.score &&
          scheduledWith == other.scheduledWith;

  @override
  int get hashCode => Object.hash(id, title, description, level, durationMin, status, score, scheduledWith);
}

class Achievement {
  const Achievement(this.label, this.icon, this.color);

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
    json['label'] as String,
    _achievementIcons[json['icon'] as String] ?? Icons.emoji_events,
    _hexColor(json['color'] as String),
  );

  final String label;
  final IconData icon;
  final Color color;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Achievement &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          icon == other.icon &&
          color == other.color;

  @override
  int get hashCode => Object.hash(label, icon, color);
}

/// Resolves a player id to the corresponding [Player]. Used while parsing
/// records that reference people (sessions, bookings, chats, tests) by id.
typedef PlayerResolver = Player Function(String id);

/// ---------------------------------------------------------------------------
/// Data access
///
/// Call [MockData.load] once during app startup (before `runApp`). After that
/// the static accessors below are populated and read synchronously by screens.
/// ---------------------------------------------------------------------------

class MockData {
  MockData._();

  static const _dir = 'assets/mock';

  static bool _loaded = false;

  static late final Player me;
  static late final List<Player> players;
  static late final List<Player> coaches;
  static late final List<Court> courts;
  static late final List<OpenSession> openSessions;
  static late final List<Booking> bookings;
  static late final List<Chat> chats;
  static late final List<SkillTest> skillTests;
  static late final List<Achievement> achievements;

  /// Every known person indexed by id (me + players + coaches) for fast
  /// lookups when a screen only has an id (e.g. a deep-linked profile).
  static final Map<String, Player> _peopleById = {};

  /// Parse all of the JSON seed data. Idempotent — safe to call more than once.
  static Future<void> load() async {
    if (_loaded) return;

    me = Player.fromJson(await _readObject('me'));
    players = await _readList('players', Player.fromJson);
    coaches = await _readList('coaches', Player.fromJson);

    for (final p in [me, ...players, ...coaches]) {
      _peopleById[p.id] = p;
    }

    courts = await _readList('courts', Court.fromJson);
    openSessions = await _readList('open_sessions', (j) => OpenSession.fromJson(j, playerById));
    bookings = await _readList('bookings', (j) => Booking.fromJson(j, playerById));
    chats = await _readList('chats', (j) => Chat.fromJson(j, playerById));
    skillTests = await _readList('skill_tests', (j) => SkillTest.fromJson(j, playerById));
    achievements = await _readList('achievements', Achievement.fromJson);

    _loaded = true;
  }

  /// Look up a person (player or coach) by id. Throws if the id is unknown,
  /// which surfaces bad references early during development.
  static Player playerById(String id) {
    final player = personByIdOrNull(id);
    if (player == null) {
      throw StateError('No player found for id "$id". Did you call MockData.load()?');
    }
    return player;
  }

  /// Look up a person (player or coach) by id, or `null` if none matches.
  /// Used where a missing id is an expected case (e.g. a deep link to a
  /// profile whose id no longer exists).
  static Player? personByIdOrNull(String id) => _peopleById[id];

  /// Look up a [Chat] by id, or `null` if none matches.
  static Chat? chatById(String id) {
    for (final c in chats) {
      if (c.id == id) return c;
    }
    return null;
  }

  /// Look up a [Court] by id, or `null` if none matches.
  static Court? courtById(String id) {
    for (final c in courts) {
      if (c.id == id) return c;
    }
    return null;
  }

  /// Look up an [OpenSession] by id, or `null` if none matches.
  static OpenSession? sessionById(String id) {
    for (final s in openSessions) {
      if (s.id == id) return s;
    }
    return null;
  }

  /// Look up a [Booking] by id, or `null` if none matches.
  static Booking? bookingById(String id) {
    for (final b in bookings) {
      if (b.id == id) return b;
    }
    return null;
  }

  /// Look up a [SkillTest] by id, or `null` if none matches.
  static SkillTest? skillTestById(String id) {
    for (final t in skillTests) {
      if (t.id == id) return t;
    }
    return null;
  }

  /// The first conversation with the given player, or `null` if there is none.
  /// Backs the "Message" action on a player's profile.
  static Chat? chatForPlayer(String playerId) {
    for (final c in chats) {
      if (c.player.id == playerId) return c;
    }
    return null;
  }

  static Future<Map<String, dynamic>> _readObject(String name) async {
    final raw = await rootBundle.loadString('$_dir/$name.json');
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  static Future<List<T>> _readList<T>(String name, T Function(Map<String, dynamic>) fromJson) async {
    final raw = await rootBundle.loadString('$_dir/$name.json');
    final list = jsonDecode(raw) as List;
    return [for (final item in list) fromJson(item as Map<String, dynamic>)];
  }
}
