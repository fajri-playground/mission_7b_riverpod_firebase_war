import 'package:hive/hive.dart';
import '../models/habit_model.dart';

/// Repository untuk operasi CRUD dengan Hive
/// 
/// Abstraksi layer data yang memisahkan business logic dari storage.
/// Mengikuti prinsip Single Responsibility dan DRY.
class HabitRepository {
  /// Nama box Hive untuk menyimpan habits
  static const String boxName = 'habits';
  
  /// Mendapatkan instance box yang sudah dibuka
  Box<Habit> get _box => Hive.box<Habit>(boxName);
  
  /// Mengambil semua habits dari storage
  List<Habit> getAllHabits() {
    return _box.values.toList();
  }
  
  /// Menambahkan habit baru
  Future<void> addHabit(Habit habit) async {
    await _box.put(habit.id, habit);
  }
  
  /// Mengupdate habit yang sudah ada
  Future<void> updateHabit(Habit habit) async {
    await _box.put(habit.id, habit);
  }
  
  /// Menghapus habit berdasarkan ID
  Future<void> deleteHabit(String id) async {
    await _box.delete(id);
  }
  
  /// Mendapatkan habit berdasarkan ID (null jika tidak ditemukan)
  Habit? getHabitById(String id) {
    return _box.get(id);
  }
  
  /// Seed data default untuk pengguna baru
  Future<void> seedDefaultHabits() async {
    if (_box.isEmpty) {
      final defaultHabits = [
        Habit(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: "Run 5 KM",
          subtitle: "Daily • 9:00 AM",
          status: "pending",
          time: "9:00 AM",
          repeat: "Daily",
          startDate: DateTime.now(),
        ),
        Habit(
          id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
          title: "Meditate",
          subtitle: "Daily • 6:00 AM",
          status: "completed",
          time: "6:00 AM",
          repeat: "Daily",
          startDate: DateTime.now(),
        ),
      ];
      
      for (final habit in defaultHabits) {
        await addHabit(habit);
      }
    }
  }
}
