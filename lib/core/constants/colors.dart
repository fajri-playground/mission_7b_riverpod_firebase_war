import 'package:flutter/material.dart';

/// Konstanta Warna Aplikasi
/// 
/// Menyimpan semua warna yang digunakan di seluruh aplikasi
/// untuk konsistensi dan kemudahan maintenance.
class AppColors {
  // --- PRIMARY COLORS ---
  /// Warna hijau utama aplikasi
  static const Color primary = Color(0xFF2FB969);
  
  /// Warna hijau lebih gelap (untuk gradient)
  static const Color primaryDark = Color(0xFF23A158);
  
  // --- BACKGROUND COLORS ---
  /// Warna background utama (hijau muda)
  static const Color background = Color(0xFFE3FFDB);
  
  /// Warna background putih (card, modal)
  static const Color surface = Colors.white;
  
  // --- TEXT COLORS ---
  /// Warna teks utama (hitam)
  static const Color textPrimary = Color(0xFF1A1A1A);
  
  /// Warna teks sekunder (abu-abu)
  static const Color textSecondary = Color(0xFF757575);
  
  /// Warna teks di atas warna primary (putih)
  static const Color textOnPrimary = Colors.white;
  
  // --- STATUS COLORS ---
  /// Warna sukses
  static const Color success = Color(0xFF2FB969);
  
  /// Warna error/bahaya
  static const Color error = Color(0xFFE53935);
  
  /// Warna warning
  static const Color warning = Color(0xFFFFA726);
  
  // --- UTILITY ---
  /// Warna border default
  static const Color border = Color(0xFFE0E0E0);
  
  /// Warna shadow
  static Color shadow = Colors.black.withOpacity(0.05);
}
