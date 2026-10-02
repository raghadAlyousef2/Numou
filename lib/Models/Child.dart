
// ===================== Enums & helpers =====================
enum LetterStatus { locked, unlocked, passed }
enum PartStatus { tried, passed }

LetterStatus letterStatusFromString(String? s) {
  switch (s) {
    case 'passed':
      return LetterStatus.passed;
    case 'unlocked':
      return LetterStatus.unlocked;
    default:
      return LetterStatus.locked;
  }
}

String letterStatusToString(LetterStatus s) {
  switch (s) {
    case LetterStatus.passed:
      return 'passed';
    case LetterStatus.unlocked:
      return 'unlocked';
    case LetterStatus.locked:
      return 'locked';
  }
}

// Part status
PartStatus partStatusFromString(String? s) =>
    (s == 'passed') ? PartStatus.passed : PartStatus.tried;

String partStatusToString(PartStatus s) =>
    (s == PartStatus.passed) ? 'passed' : 'tried';

// ===================== Part keys (new model) =====================
// Use constants to avoid typos across app & DB code.
const String kPartLetterPronunciation = 'letter_pronunciation';
const String kPartWordPronunciation   = 'word_pronunciation';
const String kPartTracing             = 'tracing';
const String kPartQuiz                = 'quiz';

// Legacy keys (for backward-compat reads only)
const String _kLegacyVideo            = 'video';
const String _kLegacyPronunciation    = 'pronunciation';

// ===================== PartProgress =====================
class PartProgress {
  final PartStatus status;     // "tried" | "passed"
  final int points;            // points earned for this part
  final int attempts;          // attempts on this part
  final double bestConfidence; // 0..1

  const PartProgress({
    this.status = PartStatus.tried,
    this.points = 0,
    this.attempts = 0,
    this.bestConfidence = 0.0,
  });

  factory PartProgress.fromJson(Map<dynamic, dynamic>? json) {
    final j = (json ?? const {});
    return PartProgress(
      status: partStatusFromString(j['status'] as String?),
      points: (j['points'] is int)
          ? j['points'] as int
          : (j['points'] as num?)?.toInt() ?? 0,
      attempts: (j['attempts'] is int)
          ? j['attempts'] as int
          : (j['attempts'] as num?)?.toInt() ?? 0,
      bestConfidence:
      (j['best_confidence'] is num) ? (j['best_confidence'] as num).toDouble() : 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': partStatusToString(status),
    'points': points,
    'attempts': attempts,
    'best_confidence': bestConfidence,
  };

  PartProgress copyWith({
    PartStatus? status,
    int? points,
    int? attempts,
    double? bestConfidence,
  }) {
    return PartProgress(
      status: status ?? this.status,
      points: points ?? this.points,
      attempts: attempts ?? this.attempts,
      bestConfidence: bestConfidence ?? this.bestConfidence,
    );
  }

  @override
  String toString() {
    return 'PartProgress(status: ${partStatusToString(status)}, '
        'points: $points, attempts: $attempts, '
        'bestConfidence: $bestConfidence)';
  }
}

// ===================== LetterProgress =====================
class LetterProgress {
  final String letterId;// e.g., "alif", "baa"


  final LetterStatus status;         // "locked" | "unlocked" | "passed"
  final int points;                  // sum of all parts' points
  final int attempts;                // total attempts across parts
  final double bestConfidence;       // aggregate (max)
  final int? lastAttemptAt;          // epoch ms
  final Map<String, PartProgress> parts; // letter_pronunciation / word_pronunciation / tracing / quiz

  LetterProgress({
    required this.letterId,
    this.status = LetterStatus.locked,
    this.points = 0,
    this.attempts = 0,
    this.bestConfidence = 0.0,
    this.lastAttemptAt,
    Map<String, PartProgress>? parts,
  }) : parts = parts ??
      const {
        kPartLetterPronunciation: PartProgress(),
        kPartWordPronunciation: PartProgress(),
        kPartTracing: PartProgress(),
        kPartQuiz: PartProgress(),
      };

  // Backward-compatible reader:
  // - If legacy 'pronunciation' exists, map it to letter_pronunciation.
  // - 'word_pronunciation' will default empty unless present.
  // - Legacy 'video' is ignored (or you could merge it into letter_pronunciation if desired).
  factory LetterProgress.fromJson(Map<dynamic, dynamic>? json, String letterId) {
    final j = (json ?? const {});

    // Read raw parts map safely
    final rawParts = (j['parts'] is Map) ? j['parts'] as Map : const {};

    // Prefer new keys; fall back to legacy
    final letterPron = (rawParts[kPartLetterPronunciation] != null)
        ? PartProgress.fromJson(rawParts[kPartLetterPronunciation] as Map?)
        : (rawParts[_kLegacyPronunciation] != null)
        ? PartProgress.fromJson(rawParts[_kLegacyPronunciation] as Map?)
        : const PartProgress();

    final wordPron = (rawParts[kPartWordPronunciation] != null)
        ? PartProgress.fromJson(rawParts[kPartWordPronunciation] as Map?)
        : const PartProgress();

    // You could optionally fold legacy 'video' into letterPron, e.g., take max confidence/points.
    // For now, we ignore it to keep behavior predictable.
    // final videoLegacy = (rawParts[_kLegacyVideo] != null)
    //     ? PartProgress.fromJson(rawParts[_kLegacyVideo] as Map?)
    //     : const PartProgress();

    final tracing =(rawParts[kPartTracing]!=null)? PartProgress.fromJson(rawParts[kPartTracing] as Map?):const PartProgress();
    final quiz = rawParts[kPartQuiz]!=null? PartProgress.fromJson(rawParts[kPartQuiz] as Map?): PartProgress();

    final p = <String, PartProgress>{
      kPartLetterPronunciation: letterPron,
      kPartWordPronunciation: wordPron,
      kPartTracing: tracing,
      kPartQuiz: quiz,
    };

    return LetterProgress(
      letterId: letterId,
      status: letterStatusFromString(j['status'] as String?),
      points: (j['points'] is int)
          ? j['points'] as int
          : (j['points'] as num?)?.toInt() ?? 0,
      attempts: (j['attempts'] is int)
          ? j['attempts'] as int
          : (j['attempts'] as num?)?.toInt() ?? 0,
      bestConfidence:
      (j['best_confidence'] is num) ? (j['best_confidence'] as num).toDouble() : 0.0,
      lastAttemptAt:
      (j['last_attempt_at'] is num) ? (j['last_attempt_at'] as num).toInt() : null,
      parts: p,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': letterStatusToString(status),
    'points': points,
    'attempts': attempts,
    'best_confidence': bestConfidence,
    if (lastAttemptAt != null) 'last_attempt_at': lastAttemptAt,
    'parts': {
      kPartLetterPronunciation: parts[kPartLetterPronunciation]?.toJson(),
      kPartWordPronunciation: parts[kPartWordPronunciation]?.toJson(),
      kPartTracing: parts[kPartTracing]?.toJson(),
      kPartQuiz: parts[kPartQuiz]?.toJson(),
    },
  };

  LetterProgress copyWith({
    LetterStatus? status,
    int? points,
    int? attempts,
    double? bestConfidence,
    int? lastAttemptAt,
    Map<String, PartProgress>? parts,
  })
  {
    return LetterProgress(
      letterId: letterId,
      status: status ?? this.status,
      points: points ?? this.points,
      attempts: attempts ?? this.attempts,
      bestConfidence: bestConfidence ?? this.bestConfidence,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      parts: parts ?? this.parts,
    );
  }

  /// Recompute letter aggregates from its parts.
  LetterProgress recomputeAggregates() {
    int sumPts = 0;
    int sumAttempts = 0;
    double maxConf = 0.0;
    bool allPassed = true;

    parts.forEach((_, part) {
      sumPts += part.points;
      sumAttempts += part.attempts;
      if (part.bestConfidence > maxConf) maxConf = part.bestConfidence;
      allPassed = allPassed && part.status == PartStatus.passed;
    });

    return copyWith(
      points: sumPts,
      attempts: sumAttempts,
      bestConfidence: maxConf,
      status: allPassed ? LetterStatus.passed : LetterStatus.unlocked,
    );
  }

  @override
  String toString() {
    return 'LetterProgress(letterId: $letterId, '
        'status: ${letterStatusToString(status)}, '
        'points: $points, attempts: $attempts, '
        'bestConfidence: $bestConfidence, '
        'lastAttemptAt: $lastAttemptAt, '
        'parts: $parts)';
  }
}

// ===================== Child =====================
class Child {
  final String childId;       // /students/{studentId}
  final String name;
  final int age;
  final String? parentId;       // "{parentUid}" or null/absent
  final Map<String, LetterProgress> levels;
  final String difficulty;
  final String? character; // e.g. 'tom', 'camel', ...
  // NEW:
  final String? avatarPath;

  Child({
    required this.childId,
    required this.name,
    required this.age,
    this.difficulty='سهل',
    this.avatarPath,
    this.parentId,
    this.character,
    Map<String, LetterProgress>? levels,
  }) : levels = levels ?? const {};

  factory Child.fromJson(Map<dynamic, dynamic>? json, String studentId)
  {
    final j = (json ?? const {});
    final levelsMap = <String, LetterProgress>{};

    if (j['levels'] is Map) {
      (j['levels'] as Map).forEach((k, v) {
        levelsMap[k as String] = LetterProgress.fromJson(v as Map?, k);
      });
    }

    return Child(
      childId: studentId,
      name: (j['name'] ?? '') as String,
      age: (j['age'] is num) ? (j['age'] as num).toInt() : 0,
      parentId: (j['parentId']??'') as String,
      avatarPath: (j['avatar']??'') as String,
      difficulty: (j['difficulty']??'') as String,
      character: (j['character'] ?? '') as String,
      levels: levelsMap,
    );
  }

  Map<String, dynamic> toJson() {
    final levelsJson = <String, dynamic>{};
    levels.forEach((k, v) => levelsJson[k] = v.toJson());

    return {
      'name': name,
      'age': age,
      if (parentId != null) 'parentId': parentId,
      if (avatarPath != null) 'avatar': avatarPath,
      if (character != null) 'character': character,
      'levels': levelsJson,
      'difficulty':difficulty
    };
  }

  Child copyWith({
    String? name,
    int? age,
    String? parentId,
    String? avatarPath,
    String? difficulty,
    String? character,
    Map<String, LetterProgress>? levels,
  })
  {
    return Child(
      childId: childId,
      name: name ?? this.name,
      age: age ?? this.age,
      parentId: parentId ?? this.parentId,
      avatarPath: avatarPath ?? this.avatarPath,
      difficulty: difficulty??'سهل',
      character: character ?? this.character,
      levels: levels ?? this.levels,
    );
  }

  @override
  String toString() {
    return 'Student(studentId: $childId, '
        'name: $name, age: $age, '
        'parentId: $parentId, '
       'avatarPath: $avatarPath, '
       'difficulty: $difficulty, '
    'character: $character'
        'levels: $levels)';

  }
}
