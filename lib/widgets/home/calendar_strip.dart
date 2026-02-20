import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/constants/colors.dart';

/// Calendar Strip Widget
/// 
/// Menampilkan strip kalender mingguan (7 hari).
/// Pengguna dapat memilih tanggal dengan menekan salah satu item hari.
class CalendarStrip extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const CalendarStrip({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final currentDate = startOfWeek.add(Duration(days: index));
        final dayName = DateFormat('E').format(currentDate)[0];
        final dayNumber = currentDate.day.toString();

        final isSelected = currentDate.day == selectedDate.day &&
            currentDate.month == selectedDate.month &&
            currentDate.year == selectedDate.year;

        return GestureDetector(
          onTap: () => onDateSelected(currentDate),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : [],
            ),
            child: Column(
              children: [
                Text(
                  dayName,
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white.withOpacity(0.8) : Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  dayNumber,
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
