import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

import '../providers/habit_provider.dart';
import '../data/models/habit_model.dart';
import '../widgets/add_habit_modal.dart';
import '../widgets/home/hero_card.dart';
import '../widgets/home/calendar_strip.dart';
import '../widgets/home/habit_item.dart';
import '../widgets/home/empty_state.dart' as empty_widget;

/// Halaman Utama (Home Page) dengan Riverpod
/// 
/// Halaman ini sudah di-refactor untuk menggunakan:
/// - ConsumerStatefulWidget untuk Riverpod integration
/// - Tidak ada setState() untuk data habits (semua via Provider)
/// - Separation of Concerns antara UI dan Business Logic
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // --- STATE VARIABLES (hanya untuk UI lokal) ---
  
  /// Nama user yang ditampilkan di header
  String _userName = 'User';
  
  /// List antrian animasi untuk habit yang baru dicentang
  final List<String> _animatingHabitIds = [];
  
  /// Controller untuk efek confetti
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  /// Memuat nama pengguna dari SharedPreferences
  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_fullname') ?? 'User';
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch state dari providers
    final habitState = ref.watch(habitProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final filteredHabits = ref.watch(filteredHabitsProvider);
    
    return Scaffold(
      backgroundColor: const Color(0xFFE3FFDB),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Loading State
          if (habitState.isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF2FB969),
              ),
            )
          else
            _buildHabitBody(filteredHabits, selectedDate),
          
          // Widget Confetti
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
            createParticlePath: _drawStar,
          ),
        ],
      ),
      
      // FAB: Tambah Habit
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          onPressed: () => _showAddHabitModal(context),
          backgroundColor: const Color(0xFF2FB969),
          shape: const CircleBorder(),
          elevation: 4,
          child: const Icon(Icons.add, color: Colors.white, size: 40),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
      // Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 12.0,
        color: Colors.white,
        child: SizedBox(
          height: 70.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // Tombol Home (Aktif)
              IconButton(
                icon: const Icon(Icons.home_filled, size: 30),
                color: const Color(0xFF2FB969),
                onPressed: () {
                  _loadUserName();
                  ref.read(habitProvider.notifier).loadHabits();
                },
              ),
              const SizedBox(width: 48),
              
              // Tombol Profile
              IconButton(
                icon: const Icon(Icons.person_outline, size: 30),
                color: Colors.grey[400],
                onPressed: () => Navigator.pushReplacementNamed(context, '/profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI: BODY UTAMA ---
  Widget _buildHabitBody(List<Habit> filteredHabits, DateTime selectedDate) {
    // Hitung progress untuk Hero Card
    final total = filteredHabits.length;
    final completed = filteredHabits.where((h) => h.isCompleted).length;
    final progress = total == 0 ? 0.0 : completed / total;
    
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // A. HEADER SECTION
                  _buildHeaderSection(selectedDate, progress, total, completed),
                  
                  const SizedBox(height: 24),
                  
                  // B. CALENDAR STRIP
                  _buildCalendarStrip(selectedDate),
                  
                  const SizedBox(height: 30),
                  
                  // C. JUDUL BAGIAN
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Your Habits",
                      style: GoogleFonts.urbanist(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // D. HABIT LIST atau EMPTY STATE
                  if (filteredHabits.isEmpty)
                    const empty_widget.EmptyState()
                  else
                    _buildHabitList(filteredHabits),
                  
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI: HEADER SECTION ---
  Widget _buildHeaderSection(DateTime selectedDate, double progress, int total, int completed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Greeting
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, $_userName",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.urbanist(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Let's make it happen!",
              style: GoogleFonts.urbanist(
                fontSize: 26,
                color: Colors.black87,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Hero Card
        HeroCard(
          selectedDate: selectedDate,
          progress: progress,
          total: total,
          completed: completed,
        ),
      ],
    );
  }

  // --- UI: CALENDAR STRIP ---
  Widget _buildCalendarStrip(DateTime selectedDate) {
    return CalendarStrip(
      selectedDate: selectedDate,
      onDateSelected: (date) {
        ref.read(selectedDateProvider.notifier).state = date;
      },
    );
  }

  // --- UI: HABIT LIST ---
  Widget _buildHabitList(List<Habit> habits) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: habits.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final habit = habits[index];
        final isAnimating = _animatingHabitIds.contains(habit.id);
        
        return HabitItemWidget(
          habit: habit,
          isAnimating: isAnimating,
          onTap: () => _showEditHabitModal(context, habit),
          onToggle: () => _handleToggleHabit(habit),
          onDelete: () => _handleDeleteHabit(habit),
        );
      },
    );
  }

  // --- HANDLERS ---
  
  /// Handle toggle status habit dengan animasi
  void _handleToggleHabit(Habit habit) {
    final isCurrentlyCompleted = habit.isCompleted || _animatingHabitIds.contains(habit.id);
    
    if (isCurrentlyCompleted) {
      // Langsung toggle ke pending
      ref.read(habitProvider.notifier).toggleHabitStatus(habit.id);
      setState(() {
        _animatingHabitIds.remove(habit.id);
      });
    } else {
      // Animasi dulu, baru update
      setState(() {
        _animatingHabitIds.add(habit.id);
      });
      
      Future.delayed(const Duration(milliseconds: 500), () async {
        if (mounted && _animatingHabitIds.contains(habit.id)) {
          // AWAIT the toggle operation to complete
          await ref.read(habitProvider.notifier).toggleHabitStatus(habit.id);
          
          setState(() {
            _animatingHabitIds.remove(habit.id);
          });
          
          // Small delay to ensure state propagates to derived providers
          await Future.delayed(const Duration(milliseconds: 100));
          
          // Cek apakah semua selesai
          if (mounted) {
            final allCompleted = ref.read(allHabitsCompletedProvider);
            if (allCompleted) {
              _confettiController.play();
              _showCelebrationDialog();
            }
          }
        }
      });
    }
  }
  
  /// Handle delete habit (konfirmasi sudah ditangani oleh widget)
  void _handleDeleteHabit(Habit habit) {
    ref.read(habitProvider.notifier).deleteHabit(habit.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Habit deleted"), duration: Duration(seconds: 2)),
    );
  }

  // --- MODALS ---
  
  /// Modal untuk tambah habit baru
  void _showAddHabitModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AddHabitModal(
          onHabitCreated: (newHabitData) {
            final newHabit = Habit.fromJson(newHabitData);
            ref.read(habitProvider.notifier).addHabit(newHabit);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Habit Created & Saved!'), backgroundColor: Colors.green),
            );
          },
        );
      },
    );
  }
  
  /// Modal untuk edit habit
  void _showEditHabitModal(BuildContext context, Habit habit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AddHabitModal(
          existingHabit: habit.toJson(),
          onHabitCreated: (updatedHabitData) {
            final updatedHabit = Habit.fromJson(updatedHabitData);
            ref.read(habitProvider.notifier).updateHabit(updatedHabit);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Habit Updated!'), backgroundColor: Colors.blue),
            );
          },
        );
      },
    );
  }
  
  /// Dialog celebrasi saat semua habit selesai
  void _showCelebrationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              const Icon(Icons.emoji_events_rounded, size: 80, color: Color(0xFF2FB969)),
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
                style: GoogleFonts.urbanist(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2FB969),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    "Awesome!",
                    style: GoogleFonts.urbanist(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Helper untuk menggambar bintang (Confetti)
  Path _drawStar(Size size) {
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
}
