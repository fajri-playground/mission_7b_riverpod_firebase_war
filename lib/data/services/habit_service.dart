import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit_model.dart';
import 'package:intl/intl.dart';

/// Service untuk mengelola data Habit
/// 
/// Memisahkan logic load/save/filter dari UI layer.
class HabitService {
  /// Kunci penyimpanan untuk SharedPreferences
  static const String _storageKey = 'my_habits';

  /// Memuat daftar habit dari SharedPreferences
  Future<List<Habit>> loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final String? habitsJson = prefs.getString(_storageKey);

    if (habitsJson != null) {
      final List<dynamic> decoded = jsonDecode(habitsJson);
      return decoded.map((json) => Habit.fromJson(json)).toList();
    } else {
      // Data bawaan untuk pengguna baru
      return _getDefaultHabits();
    }
  }

  /// Menyimpan daftar habit ke SharedPreferences
  Future<void> saveHabits(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    final String habitsJson = jsonEncode(habits.map((h) => h.toJson()).toList());
    await prefs.setString(_storageKey, habitsJson);
  }

  /// Filter habit berdasarkan tanggal
  List<Habit> filterByDate(List<Habit> habits, DateTime selectedDate) {
    return habits.where((habit) {
      final checkDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      final start = DateTime(habit.startDate.year, habit.startDate.month, habit.startDate.day);

      // Cek apakah sebelum start date
      if (checkDate.isBefore(start)) return false;

      // Cek apakah setelah end date
      if (habit.endDate != null) {
        final end = DateTime(habit.endDate!.year, habit.endDate!.month, habit.endDate!.day);
        if (checkDate.isAfter(end)) return false;
      }

      // Cek repeat type
      String repeat = habit.repeat;
      if (repeat == 'Daily') return true;

      if (repeat == 'Weekly' || repeat == 'Specific Days') {
        if (habit.specificDays != null && habit.specificDays!.length == 7) {
          int weekdayIndex = selectedDate.weekday - 1;
          return habit.specificDays![weekdayIndex] == true;
        }
      }

      return true;
    }).toList();
  }

  /// Mengurutkan habit (pending dulu, lalu by time)
  List<Habit> sortHabits(List<Habit> habits) {
    habits.sort((a, b) {
      // Pending dulu
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }

      // Lalu by time
      int timeA = _parseTimeVal(a.time);
      int timeB = _parseTimeVal(b.time);
      return timeA.compareTo(timeB);
    });
    return habits;
  }

  /// Parse time string ke menit (untuk sorting)
  int _parseTimeVal(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return 9999;
    try {
      timeStr = timeStr.replaceAll(RegExp(r'\s+'), ' ').trim();
      DateTime dt;
      if (timeStr.toUpperCase().contains('AM') || timeStr.toUpperCase().contains('PM')) {
        dt = DateFormat("h:mm a").parse(timeStr);
      } else {
        dt = DateFormat("HH:mm").parse(timeStr);
      }
      return dt.hour * 60 + dt.minute;
    } catch (e) {
      return 9999;
    }
  }

  /// Data bawaan untuk pengguna baru
  List<Habit> _getDefaultHabits() {
    return [
      Habit(
        id: '1',
        title: "Run 5 KM",
        subtitle: "Daily • 9:00 AM",
        status: "pending",
        time: "9:00 AM",
        repeat: "Daily",
        startDate: DateTime.now(),
      ),
      Habit(
        id: '2',
        title: "Meditate",
        subtitle: "Daily • 6:00 AM",
        status: "completed",
        time: "6:00 AM",
        repeat: "Daily",
        startDate: DateTime.now(),
      ),
    ];
  }
}
