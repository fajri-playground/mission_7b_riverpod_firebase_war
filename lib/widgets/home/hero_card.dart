import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/constants/colors.dart';

/// Hero Card Widget
/// 
/// Menampilkan ringkasan progress habit harian dalam bentuk card gradient.
/// Termasuk tanggal, title "Daily Goals", motivational text, dan progress bar.
class HeroCard extends StatelessWidget {
  final DateTime selectedDate;
  final double progress;
  final int total;
  final int completed;

  const HeroCard({
    super.key,
    required this.selectedDate,
    required this.progress,
    required this.total,
    required this.completed,
  });

  /// Teks motivasi berdasarkan progress
  String get motivationalText {
    if (progress == 1.0) return "All Done! Amazing Job! 🎉";
    if (progress >= 0.5) return "You're halfway there! Keep going!";
    return "Start small, win big. Let's go!";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris: Tanggal & Persentase
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEEE, d MMM').format(selectedDate),
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Daily Goals",
                    style: GoogleFonts.urbanist(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // Badge Persentase
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${(progress * 100).toInt()}%",
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Teks Motivasi
          Text(
            motivationalText,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              color: Colors.white.withOpacity(0.85),
            ),
          ),

          const SizedBox(height: 12),

          // Progress Bar (Bar Kemajuan)
          LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  // Track (Latar belakang)
                  Container(
                    height: 12,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  // Indikator (Pengisi)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.fastOutSlowIn,
                    height: 12,
                    width: constraints.maxWidth * progress,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 8),

          // Teks Statistik
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "$completed/$total Habits Completed",
              style: GoogleFonts.urbanist(
                fontSize: 12,
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
