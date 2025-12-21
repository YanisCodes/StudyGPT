import 'dart:convert';

class StudySession {
  final String moduleName;
  final int durationInSeconds;
  final DateTime date;
  final String? notes;
  final int xpEarned;

  StudySession({
    required this.moduleName,
    required this.durationInSeconds,
    required this.date,
    this.notes,
    this.xpEarned = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'moduleName': moduleName,
      'durationInSeconds': durationInSeconds,
      'date': date.toIso8601String(),
      'notes': notes,
      'xpEarned': xpEarned,
    };
  }

  factory StudySession.fromMap(Map<String, dynamic> map) {
    return StudySession(
      moduleName: map['moduleName'],
      durationInSeconds: map['durationInSeconds'],
      date: DateTime.parse(map['date']),
      notes: map['notes'],
      xpEarned: map['xpEarned'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory StudySession.fromJson(String source) =>
      StudySession.fromMap(json.decode(source));
}
