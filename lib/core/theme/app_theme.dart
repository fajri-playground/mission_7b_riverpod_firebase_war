import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

/// Tema Aplikasi Terpusat
/// 
/// Menyediakan ThemeData untuk MaterialApp.
class AppTheme {
  /// Tema Terang (Default)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      
      // Warna Utama
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      
      // Skema Warna
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.primaryDark,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      
      // Tema AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.urbanist(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      
      // Tema Tombol Aksi Mengambang (FAB)
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),
      
      // Tema Navigasi Bawah
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
      ),
      
      // Tema Tombol Elevated
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      // Tema Card
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      
      // Tema Dekorasi Input
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      
      // Tema Teks
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.urbanist(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.urbanist(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        titleLarge: GoogleFonts.urbanist(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.urbanist(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.urbanist(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
