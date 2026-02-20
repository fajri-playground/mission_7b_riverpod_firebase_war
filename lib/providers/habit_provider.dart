import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../data/models/habit_model.dart';
import '../data/repositories/habit_repository.dart';

/// State untuk habit list
/// 
/// Immutable state class mengikuti best practices Riverpod.
class HabitState {
  final List<Habit> habits;
  final bool isLoading;
  final String? error;
  
  const HabitState({
    this.habits = const [],
    this.isLoading = false,
    this.error,
  });
  
  HabitState copyWith({
    List<Habit>? habits,
    bool? isLoading,
    String? error,
  }) {
    return HabitState(
      habits: habits ?? this.habits,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier untuk mengelola habit list
/// 
/// Semua business logic CRUD ada di sini, UI cukup memanggil method-nya.
/// Mengikuti prinsip Separation of Concerns.
class HabitNotifier extends StateNotifier<HabitState> {
  final HabitRepository _repository;
  
  HabitNotifier(this._repository) : super(const HabitState(isLoading: true)) {
    loadHabits();
  }
  
  /// Load habits dari Hive saat pertama kali
  Future<void> loadHabits() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // Seed default habits jika kosong
      await _repository.seedDefaultHabits();
      
      final habits = _repository.getAllHabits();
      state = state.copyWith(habits: habits, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
  
  /// Menambahkan habit baru
  Future<void> addHabit(Habit habit) async {
    try {
      await _repository.addHabit(habit);
      state = state.copyWith(habits: [...state.habits, habit]);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
  
  /// Mengupdate habit
  Future<void> updateHabit(Habit habit) async {
    try {
      await _repository.updateHabit(habit);
      final updatedList = state.habits.map((h) {
        return h.id == habit.id ? habit : h;
      }).toList();
      state = state.copyWith(habits: updatedList);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
  
  /// Menghapus habit
  Future<void> deleteHabit(String id) async {
    try {
      await _repository.deleteHabit(id);
      final updatedList = state.habits.where((h) => h.id != id).toList();
      state = state.copyWith(habits: updatedList);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
  
  /// Toggle status habit (pending <-> completed)
  Future<void> toggleHabitStatus(String id) async {
    try {
      final habit = state.habits.firstWhere((h) => h.id == id);
      final newStatus = habit.isCompleted ? 'pending' : 'completed';
      final updatedHabit = habit.copyWith(status: newStatus);
      
      await _repository.updateHabit(updatedHabit);
      
      final updatedList = state.habits.map((h) {
        return h.id == id ? updatedHabit : h;
      }).toList();
      state = state.copyWith(habits: updatedList);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

// ============================================================================
// PROVIDERS
// ============================================================================

/// Provider untuk repository (dependency injection)
final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  return HabitRepository();
});

/// Provider utama untuk habit state
final habitProvider = StateNotifierProvider<HabitNotifier, HabitState>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return HabitNotifier(repository);
});

/// Provider untuk tanggal yang dipilih
final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

/// Provider untuk habits yang sudah difilter berdasarkan tanggal
final filteredHabitsProvider = Provider<List<Habit>>((ref) {
  final state = ref.watch(habitProvider);
  final selectedDate = ref.watch(selectedDateProvider);
  
  if (state.isLoading) return [];
  
  // Filter berdasarkan tanggal dan repeat type
  final filtered = state.habits.where((habit) {
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
    if (habit.repeat == 'Daily') return true;
    
    if (habit.repeat == 'Weekly' || habit.repeat == 'Specific Days') {
      if (habit.specificDays != null && habit.specificDays!.length == 7) {
        int weekdayIndex = selectedDate.weekday - 1;
        return habit.specificDays![weekdayIndex] == true;
      }
    }
    
    return true;
  }).toList();
  
  // Sort: pending dulu, lalu by time
  filtered.sort((a, b) {
    // Pending dulu
    if (a.isCompleted != b.isCompleted) {
      return a.isCompleted ? 1 : -1;
    }
    
    // Lalu by time
    int timeA = _parseTimeVal(a.time);
    int timeB = _parseTimeVal(b.time);
    return timeA.compareTo(timeB);
  });
  
  return filtered;
});

/// Helper function untuk parse time string ke menit
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

/// Provider untuk cek apakah semua habit hari ini sudah selesai
final allHabitsCompletedProvider = Provider<bool>((ref) {
  final filtered = ref.watch(filteredHabitsProvider);
  if (filtered.isEmpty) return false;
  return filtered.every((h) => h.isCompleted);
});
