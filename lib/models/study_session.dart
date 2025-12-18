import 'dart:convert';

class StudySession {
  final String moduleName;
  final int durationInSeconds;
  final DateTime date;

  StudySession({
    required this.moduleName,
    required this.durationInSeconds,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'moduleName': moduleName,
      'durationInSeconds': durationInSeconds,
      'date': date.toIso8601String(),
    };
  }

  factory StudySession.fromMap(Map<String, dynamic> map) {
    return StudySession(
      moduleName: map['moduleName'],
      durationInSeconds: map['durationInSeconds'],
      date: DateTime.parse(map['date']),
    );
  }

  String toJson() => json.encode(toMap());

  factory StudySession.fromJson(String source) =>
      StudySession.fromMap(json.decode(source));
}
