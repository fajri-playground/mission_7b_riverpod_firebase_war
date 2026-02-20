import 'package:hive/hive.dart';

part 'habit_model.g.dart';

/// Model Habit dengan Hive Annotations
/// 
/// Representasi type-safe dari data habit yang dapat disimpan ke Hive.
/// TypeAdapter akan di-generate otomatis oleh build_runner.
@HiveType(typeId: 0)
class Habit extends HiveObject {
  /// ID unik habit
  @HiveField(0)
  final String id;
  
  /// Judul habit
  @HiveField(1)
  final String title;
  
  /// Subjudul/deskripsi singkat
  @HiveField(2)
  final String subtitle;
  
  /// Waktu pelaksanaan (format: "9:00 AM")
  @HiveField(3)
  final String time;
  
  /// Tipe pengulangan: 'Daily', 'Weekly', 'Specific Days'
  @HiveField(4)
  final String repeat;
  
  /// Tanggal mulai habit
  @HiveField(5)
  final DateTime startDate;
  
  /// Tanggal berakhir (opsional)
  @HiveField(6)
  final DateTime? endDate;
  
  /// Status: 'pending' atau 'completed'
  @HiveField(7)
  String status;
  
  /// Hari-hari spesifik untuk repeat (index 0-6 = Senin-Minggu)
  @HiveField(8)
  final List<bool>? specificDays;

  Habit({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.repeat,
    required this.startDate,
    this.endDate,
    this.status = 'pending',
    this.specificDays,
  });

  /// Factory constructor dari JSON (Map)
  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      time: json['time'] ?? '',
      repeat: json['repeat'] ?? 'Daily',
      startDate: json['startDate'] != null 
          ? DateTime.parse(json['startDate']) 
          : DateTime.now(),
      endDate: json['endDate'] != null 
          ? DateTime.parse(json['endDate']) 
          : null,
      status: json['status'] ?? 'pending',
      specificDays: json['specificDays'] != null 
          ? List<bool>.from(json['specificDays']) 
          : null,
    );
  }

  /// Mengubah Habit menjadi JSON (Map)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'time': time,
      'repeat': repeat,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'status': status,
      'specificDays': specificDays,
    };
  }

  /// Membuat salinan dengan perubahan tertentu
  Habit copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? time,
    String? repeat,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    List<bool>? specificDays,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      time: time ?? this.time,
      repeat: repeat ?? this.repeat,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      specificDays: specificDays ?? this.specificDays,
    );
  }

  /// Cek apakah habit sudah selesai
  bool get isCompleted => status == 'completed';

  @override
  String toString() => 'Habit(id: $id, title: $title, status: $status)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Habit && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
