import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/models/habit_model.dart';
import 'data/repositories/habit_repository.dart';
import 'pages/welcome_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart';

void main() async {
  // Pastikan Flutter binding sudah siap
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inisialisasi Hive
  await Hive.initFlutter();
  
  // Register TypeAdapter untuk model Habit
  Hive.registerAdapter(HabitAdapter());
  
  // Buka box untuk menyimpan habits
  await Hive.openBox<Habit>(HabitRepository.boxName);
  
  // Jalankan aplikasi dengan ProviderScope
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HabitLy',
      // Konfigurasi Tema Aplikasi
      theme: ThemeData(
        // Warna Utama (Primary): #2FB969 (Hijau HabitLy)
        // Background: #E3FFDB (Hijau Muda)
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2FB969),
          primary: const Color(0xFF2FB969),
          background: const Color(0xFFE3FFDB),
          surface: const Color(0xFFE3FFDB),
        ),
        scaffoldBackgroundColor: const Color(0xFFE3FFDB),
        useMaterial3: true,
      ),
      // Mendifinisikan Rute Awal
      initialRoute: '/',
      // Mendaftarkan Rute Halaman (Named Routes)
      routes: {
        '/': (context) => const WelcomePage(), // Halaman Sambutan
        '/login': (context) => const LoginPage(), // Halaman Login
        '/register': (context) => const RegisterPage(), // Halaman Register
        '/home': (context) => const HomePage(), // Halaman Utama (Setelah Login)
        '/profile': (context) => const ProfilePage(), // Halaman Profil
      },
    );
  }
}
