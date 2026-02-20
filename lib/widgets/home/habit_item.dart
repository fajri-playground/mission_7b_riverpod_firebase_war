import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';
import '../../data/models/habit_model.dart';

/// Habit Item Widget
/// 
/// Widget individual untuk setiap habit dalam list.
/// Mendukung fitur 'Swipe to Delete' dengan konfirmasi dan animasi checklist.
class HabitItemWidget extends StatelessWidget {
  final Habit habit;
  final bool isAnimating;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const HabitItemWidget({
    super.key,
    required this.habit,
    required this.isAnimating,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  /// Apakah secara visual terlihat completed (termasuk saat animasi)
  bool get isVisualCompleted => habit.isCompleted || isAnimating;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(habit.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      confirmDismiss: (direction) => _showDeleteConfirmation(context),
      onDismissed: (direction) => onDelete(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            // Konten (Judul & Subjudul)
            Expanded(
              child: GestureDetector(
                onTap: onTap,
                behavior: HitTestBehavior.translucent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.title,
                      style: GoogleFonts.urbanist(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        decoration: isVisualCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      habit.subtitle,
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[500],
                        decoration: isVisualCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Kotak Centang (Checkbox)
            GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isVisualCompleted ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isVisualCompleted ? AppColors.primary : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: isVisualCompleted
                    ? const Icon(Icons.check, size: 18, color: Colors.white)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Menampilkan dialog konfirmasi hapus
  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            "Delete Habit?",
            style: GoogleFonts.urbanist(fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Are you sure you want to remove this habit?\nThis action cannot be undone.",
            style: GoogleFonts.urbanist(color: Colors.grey[600]),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                "Cancel",
                style: GoogleFonts.urbanist(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                "Delete",
                style: GoogleFonts.urbanist(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
