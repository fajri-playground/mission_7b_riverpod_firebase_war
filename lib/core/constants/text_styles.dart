import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// Konstanta TextStyle Aplikasi
/// 
/// Menyimpan semua TextStyle yang digunakan di seluruh aplikasi
/// untuk konsistensi typography.
class AppTextStyles {
  // --- HEADING ---
  /// Heading XL (untuk judul utama di hero card)
  static TextStyle headingXL = GoogleFonts.urbanist(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );
  
  /// Heading Large (untuk judul section)
  static TextStyle headingLarge = GoogleFonts.urbanist(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  /// Heading Medium (untuk judul card)
  static TextStyle headingMedium = GoogleFonts.urbanist(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  // --- BODY TEXT ---
  /// Body Large (untuk konten utama)
  static TextStyle bodyLarge = GoogleFonts.urbanist(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  /// Body Medium (untuk konten standar)
  static TextStyle bodyMedium = GoogleFonts.urbanist(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
  
  /// Body Small (untuk caption)
  static TextStyle bodySmall = GoogleFonts.urbanist(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
  
  // --- TOMBOL ---
  /// Teks untuk tombol
  static TextStyle button = GoogleFonts.urbanist(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textOnPrimary,
  );
  
  // --- KHUSUS ---
  /// Teks sapaan (Hello, User)
  static TextStyle greeting = GoogleFonts.urbanist(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 0.2,
  );
  
  /// Judul Habit
  static TextStyle habitTitle = GoogleFonts.urbanist(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  /// Subjudul Habit
  static TextStyle habitSubtitle = GoogleFonts.urbanist(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
}
