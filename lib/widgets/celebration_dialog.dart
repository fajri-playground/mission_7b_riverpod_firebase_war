import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import '../core/constants/colors.dart';

/// Celebration Dialog Widget
/// 
/// Menampilkan dialog dan confetti ketika semua task selesai.
class CelebrationDialog extends StatelessWidget {
  const CelebrationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          const Icon(Icons.emoji_events_rounded, size: 80, color: AppColors.primary),
          const SizedBox(height: 20),
          Text(
            "You owned this day!",
            textAlign: TextAlign.center,
            style: GoogleFonts.urbanist(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "All tasks completed.\nSee you tomorrow!",
            textAlign: TextAlign.center,
            style: GoogleFonts.urbanist(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                "Awesome!",
                style: GoogleFonts.urbanist(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Menampilkan dialog selebrasi dengan confetti
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CelebrationDialog(),
    );
  }
}

/// Helper untuk menggambar bintang (Confetti)
Path drawStar(Size size) {
  double degToRad(double deg) => deg * (pi / 180.0);

  const numberOfPoints = 5;
  final halfWidth = size.width / 2;
  final externalRadius = halfWidth;
  final internalRadius = halfWidth / 2.5;
  final degreesPerStep = degToRad(360 / numberOfPoints);
  final halfDegreesPerStep = degreesPerStep / 2;
  final path = Path();
  final fullAngle = degToRad(360);
  path.moveTo(size.width, halfWidth);

  for (double step = 0; step < fullAngle; step += degreesPerStep) {
    path.lineTo(halfWidth + externalRadius * cos(step),
        halfWidth + externalRadius * sin(step));
    path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
        halfWidth + internalRadius * sin(step + halfDegreesPerStep));
  }
  path.close();
  return path;
}
