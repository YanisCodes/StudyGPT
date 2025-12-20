import 'dart:async';
import 'package:flutter/material.dart';
import '../models/study_session.dart';
import '../services/storage_service.dart';

class StudyProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();

  // User Input State
  double _fatigue = 50.0;
  final List<String> _modules = [];
  String? _selectedModule;

  // Timer State
  Timer? _timer;
  int _secondsRemaining = 0;
  int _initialDuration = 0;
  bool _isRunning = false;
  bool _isBreak = false;
  
  // Data State
  List<StudySession> _sessions = [];
  double _targetHours = 4.0;

  // Getters
  double get fatigue => _fatigue;
  List<String> get modules => _modules;
  String? get selectedModule => _selectedModule;
  int get secondsRemaining => _secondsRemaining;
  int get initialDuration => _initialDuration;
  bool get isRunning => _isRunning;
  bool get isBreak => _isBreak;
  List<StudySession> get sessions => _sessions;
  double get targetHours => _targetHours;

  double get progress => _initialDuration == 0 ? 0 : 1 - (_secondsRemaining / _initialDuration);

  StudyProvider() {
    _loadSessions();
    _loadModules();
    _loadTargetHours();
  }

  void setTargetHours(double hours) {
    _targetHours = hours;
    _storageService.saveTargetHours(hours);
    notifyListeners();
  }

  Future<void> _loadTargetHours() async {
    _targetHours = await _storageService.getTargetHours();
    notifyListeners();
  }

  Future<void> clearData() async {
    await _storageService.clearAll();
    _sessions.clear();
    _modules.clear();
    _selectedModule = null;
    _targetHours = 4.0;
    notifyListeners();
  }

  void setFatigue(double value) {
    _fatigue = value;
    notifyListeners();
  }

  void addModule(String module) {
    if (!_modules.contains(module)) {
      _modules.add(module);
      _saveModules();
      notifyListeners();
    }
  }

  void removeModule(String module) {
    _modules.remove(module);
    _saveModules();
    notifyListeners();
  }

  void selectModule(String module) {
    _selectedModule = module;
    notifyListeners();
  }

  // Logic to calculate study duration based on fatigue
  int get calculatedStudyMinutes {
    // Base 50 mins, reduce by fatigue factor
    // Fatigue 0 -> 50 mins
    // Fatigue 100 -> 20 mins
    return (50 - (_fatigue * 0.3)).round().clamp(20, 60);
  }

  int get calculatedBreakMinutes {
    // Base 5 mins, increase with fatigue
    // Fatigue 0 -> 5 mins
    // Fatigue 100 -> 15 mins
    return (5 + (_fatigue * 0.1)).round().clamp(5, 30);
  }

  void startSession() {
    _isBreak = false;
    _initialDuration = calculatedStudyMinutes * 60;
    _secondsRemaining = _initialDuration;
    _startTimer();
  }

  void startBreak() {
    _isBreak = true;
    _initialDuration = calculatedBreakMinutes * 60;
    _secondsRemaining = _initialDuration;
    _startTimer();
  }

  void _startTimer() {
    _isRunning = true;
    _timer?.cancel();
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        notifyListeners();
      } else {
        _completeTimer();
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void resumeTimer() {
    _startTimer();
  }

  void stopTimer() {
    _timer?.cancel();
    _isRunning = false;
    _secondsRemaining = 0;
    notifyListeners();
  }

  void _completeTimer() {
    _timer?.cancel();
    _isRunning = false;
    
    if (!_isBreak && _selectedModule != null) {
      // Save study session
      final session = StudySession(
        moduleName: _selectedModule!,
        durationInSeconds: _initialDuration,
        date: DateTime.now(),
      );
      _saveSession(session);
    }
    
    notifyListeners();
  }

  Future<void> _loadSessions() async {
    _sessions = await _storageService.getSessions();
    notifyListeners();
  }

  Future<void> _saveSession(StudySession session) async {
    await _storageService.saveSession(session);
    _sessions.add(session);
    notifyListeners();
  }

  Future<void> _loadModules() async {
    final loadedModules = await _storageService.getModules();
    _modules.clear();
    _modules.addAll(loadedModules);
    notifyListeners();
  }

  Future<void> _saveModules() async {
    await _storageService.saveModules(_modules);
  }

  double get hoursStudiedToday {
    final now = DateTime.now();
    final todaySessions = _sessions.where((s) =>
        s.date.year == now.year &&
        s.date.month == now.month &&
        s.date.day == now.day);
    final totalSeconds = todaySessions.fold(0, (sum, s) => sum + s.durationInSeconds);
    return totalSeconds / 3600;
  }

  List<double> get last7DaysHours {
    final now = DateTime.now();
    List<double> dailyHours = [];
    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final daySessions = _sessions.where((s) =>
          s.date.year == day.year &&
          s.date.month == day.month &&
          s.date.day == day.day);
      final totalSeconds = daySessions.fold(0, (sum, s) => sum + s.durationInSeconds);
      dailyHours.add(totalSeconds / 3600);
    }
    return dailyHours;
  }

  int get focusScore {
    // Simple logic: 100% if sessions > 0, else 0% for now.
    // In future, track interruptions or pauses.
    if (_sessions.isEmpty) return 0;
    // Mock logic: Random fluctuation between 85-100 based on session count to make it look alive
    return (85 + (_sessions.length % 15)).clamp(0, 100);
  }
}
