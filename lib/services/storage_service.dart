import 'package:shared_preferences/shared_preferences.dart';
import '../models/study_session.dart';

class StorageService {
  static const String _sessionsKey = 'study_sessions';
  static const String _modulesKey = 'study_modules';
  static const String _targetHoursKey = 'target_hours';

  Future<void> saveSession(StudySession session) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> sessions = prefs.getStringList(_sessionsKey) ?? [];
    sessions.add(session.toJson());
    await prefs.setStringList(_sessionsKey, sessions);
  }

  Future<List<StudySession>> getSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> sessions = prefs.getStringList(_sessionsKey) ?? [];
    return sessions.map((s) => StudySession.fromJson(s)).toList();
  }

  Future<void> saveModules(List<String> modules) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_modulesKey, modules);
  }

  Future<List<String>> getModules() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_modulesKey) ?? [];
  }

  Future<void> saveTargetHours(double hours) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_targetHoursKey, hours);
  }

  Future<double> getTargetHours() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_targetHoursKey) ?? 4.0;
  }

  Future<void> clearSessions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionsKey);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
