import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';

/// Empty State Widget
/// 
/// Ditampilkan ketika tidak ada habit untuk hari yang dipilih.
class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const EmptyState({
    super.key,
    this.title = "No Habits Found",
    this.subtitle = "You have no tasks for this day.\nEnjoy your free time or add a new one!",
    this.icon = Icons.history_toggle_off_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 48),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Center(
              child: Icon(icon, size: 48, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: GoogleFonts.urbanist(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              color: Colors.grey[500],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
