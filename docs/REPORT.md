# 📋 Laporan Proyek: HabitLy

## 📖 Pendahuluan

### Latar Belakang
Dalam era digital saat ini, banyak orang kesulitan membangun dan mempertahankan kebiasaan positif. Aplikasi habit tracker menjadi solusi untuk membantu pengguna melacak aktivitas harian mereka secara konsisten.

### Tujuan Proyek
Membangun aplikasi mobile **HabitLy** menggunakan Flutter yang dapat:
1. Membantu pengguna mencatat dan melacak kebiasaan harian
2. Memberikan visualisasi progress yang jelas
3. Memberikan motivasi melalui efek selebrasi
4. **Menyimpan data secara permanen** (tidak hilang setelah restart)

### Target Pengguna
- Individu yang ingin membangun rutinitas positif
- Pengguna yang membutuhkan pengingat aktivitas harian
- Siapa saja yang ingin meningkatkan produktivitas

---

## 📝 Studi Kasus & Tugas Assignment

### Studi Kasus
Startup **Habitly** mendapatkan masukan dari pengguna bahwa **data kebiasaan mereka hilang setiap kali aplikasi di-restart**. Sebagai Mobile Developer, tugas adalah melakukan refactoring besar-besaran agar aplikasi ini lebih "pintar" dengan menyimpan data secara lokal dan menggunakan arsitektur state management yang lebih modern.

### Tujuan Utama Assignment

| # | Tujuan | Deskripsi |
|---|--------|-----------|
| 1 | **Separation of Concerns** | Memisahkan logika bisnis (data management) dengan tampilan (UI) menggunakan Riverpod |
| 2 | **Manajemen State Reaktif** | UI langsung memperbarui dirinya secara reaktif saat data berubah |
| 3 | **Data Persistence** | Menjamin data tidak hilang dengan penyimpanan permanen menggunakan Hive |
| 4 | **Optimasi Performa** | Menggunakan Hive NoSQL yang lebih cepat untuk kebutuhan mobile |

### Daftar Tugas & Status Penyelesaian

#### Tugas 1: Migrasi State ✅
> Pindahkan seluruh logika bisnis (CRUD) dari UI ke Riverpod Provider

**Implementasi:**
- `HabitNotifier` di `lib/providers/habit_provider.dart` menangani semua CRUD
- UI hanya memanggil `ref.read(habitProvider.notifier).method()`

#### Tugas 2: Implementasi Local Database ✅
> Integrasikan Hive sebagai database NoSQL ringan

**Implementasi:**
- `HabitRepository` di `lib/data/repositories/habit_repository.dart`
- Hive Box `'habits'` untuk menyimpan data

#### Tugas 3: Sinkronisasi ✅
> Setiap perubahan langsung tersimpan ke Hive melalui Riverpod

**Implementasi:**
```dart
// Di HabitNotifier
Future<void> addHabit(Habit habit) async {
  await _repository.addHabit(habit);  // ← Auto-save
  state = state.copyWith(habits: [...state.habits, habit]);
}
```

#### Tugas 4: Ketentuan Manajemen State (Riverpod) ✅
> Gunakan StateNotifierProvider, UI tidak mengolah data langsung

**Implementasi:**
- `StateNotifierProvider<HabitNotifier, HabitState>` di `habit_provider.dart`
- UI menggunakan `ref.watch()` dan `ref.read()` saja

#### Tugas 5: Ketentuan Persistensi Data (Hive) ✅
> TypeAdapter, loading dari Hive Box, data tetap ada setelah restart

**Implementasi:**
- `@HiveType` & `@HiveField` annotations di `habit_model.dart`
- `HabitAdapter` generated di `habit_model.g.dart`
- Auto-load di `HabitNotifier` constructor

#### Tugas 6: Ketentuan UI Enhancement ✅
> Loading State & Empty State

**Implementasi:**
- `CircularProgressIndicator` saat `isLoading == true`
- `EmptyState` widget saat `filteredHabits.isEmpty`

### Ketentuan yang Dipenuhi

| Kategori | Ketentuan | Status |
|----------|-----------|--------|
| **Clean Code** | No setState untuk data habits | ✅ |
| **Clean Code** | Separation UI vs Logic | ✅ |
| **Database** | Auto-Save ke Hive | ✅ |
| **Database** | Persistent setelah restart | ✅ |
| **UI/UX** | Konfirmasi hapus (Dialog) | ✅ |
| **UI/UX** | Loading State | ✅ |
| **UI/UX** | Empty State | ✅ |

---

## ✨ Fitur Aplikasi

### 1. Sistem Autentikasi
- **Login & Register** dengan validasi input
- Penyimpanan kredensial menggunakan SharedPreferences
- Data habit terpisah per akun pengguna

### 2. Manajemen Habit
- **Tambah** habit baru dengan modal bottom sheet
- **Edit** habit yang sudah ada
- **Hapus** dengan konfirmasi dialog
- **Tandai selesai** dengan animasi centang
- **Auto-save** ke database lokal (Hive)

### 3. Kalender Interaktif
- Strip kalender mingguan
- Navigasi antar tanggal
- Filter habit berdasarkan tanggal

### 4. Progress Tracking
- Hero Card dengan progress bar
- Persentase penyelesaian harian
- Teks motivasi dinamis

### 5. Selebrasi
- Efek confetti saat semua task selesai
- Dialog "You owned this day!"

### 6. Data Persistence
- Data tersimpan secara permanen di device
- Tidak hilang setelah aplikasi ditutup/restart
- Loading state saat mengambil data dari database

---

## 🏗️ Arsitektur Aplikasi

### Clean Architecture (Separation of Concerns)

Aplikasi ini menggunakan arsitektur berlapis untuk memisahkan antara UI dan Business Logic:

```
┌─────────────────────────────────────────────────────────┐
│                      UI LAYER                            │
│     (Pages, Widgets, Screens)                           │
│     - Hanya menampilkan data                            │
│     - Tidak ada business logic                          │
│     - Menggunakan ConsumerWidget/ConsumerStatefulWidget │
└────────────────────────┬────────────────────────────────┘
                         │ ref.watch() / ref.read()
┌────────────────────────▼────────────────────────────────┐
│                   PROVIDER LAYER                         │
│     (StateNotifier, Providers, State)                   │
│     - Mengelola state aplikasi                          │
│     - Business logic (filter, sort, CRUD)               │
│     - Reactive updates ke UI                            │
└────────────────────────┬────────────────────────────────┘
                         │ CRUD operations
┌────────────────────────▼────────────────────────────────┐
│                  REPOSITORY LAYER                        │
│     (HabitRepository)                                   │
│     - Abstraksi akses data                              │
│     - Tidak tahu tentang UI atau Provider               │
└────────────────────────┬────────────────────────────────┘
                         │ read/write
┌────────────────────────▼────────────────────────────────┐
│                    DATA LAYER                            │
│     (Hive Box, Models, TypeAdapters)                    │
│     - Penyimpanan permanen di device                    │
│     - NoSQL database                                    │
└─────────────────────────────────────────────────────────┘
```

### Struktur Folder

```
lib/
├── main.dart                     # Entry point + Hive init + ProviderScope
├── core/                         # Fondasi aplikasi
│   ├── constants/
│   │   ├── colors.dart           # Konstanta warna (AppColors)
│   │   └── text_styles.dart      # Konstanta TextStyle
│   └── theme/
│       └── app_theme.dart        # ThemeData terpusat
├── data/                         # Data layer
│   ├── models/
│   │   ├── habit_model.dart      # Model Habit + Hive annotations
│   │   └── habit_model.g.dart    # Generated TypeAdapter
│   ├── repositories/
│   │   └── habit_repository.dart # CRUD operations dengan Hive
│   └── services/
│       └── habit_service.dart    # Legacy service (deprecated)
├── providers/                    # Provider layer (Riverpod)
│   └── habit_provider.dart       # StateNotifier + Providers
├── pages/                        # UI layer
│   ├── welcome_page.dart
│   ├── login_page.dart
│   ├── register_page.dart
│   ├── home_page.dart            # ConsumerStatefulWidget
│   └── profile_page.dart
└── widgets/                      # Komponen reusable
    ├── add_habit_modal.dart
    ├── celebration_dialog.dart
    └── home/
        ├── hero_card.dart
        ├── calendar_strip.dart
        ├── habit_item.dart       # + Delete confirmation
        └── empty_state.dart
```

---

## 🛠️ Teknologi yang Digunakan

| Teknologi | Fungsi |
|-----------|--------|
| **Flutter 3.10.3** | Framework UI cross-platform |
| **Dart** | Bahasa pemrograman |
| **Riverpod** | State management modern & reaktif |
| **Hive** | Database NoSQL lokal yang cepat |
| **SharedPreferences** | Penyimpanan data user (nama, email) |
| **Google Fonts** | Typography (Urbanist) |
| **Confetti** | Efek selebrasi |
| **intl** | Format tanggal |

### Perbandingan Sebelum vs Sesudah Refactoring

| Aspek | SEBELUM | SESUDAH |
|-------|---------|---------|
| State Management | `setState()` | Riverpod (StateNotifierProvider) |
| Database | SharedPreferences (JSON) | Hive (NoSQL) |
| Arsitektur | Monolithic (UI + Logic campur) | Layered (UI ↔ Provider ↔ Repository) |
| Data Persistence | ❌ Hilang setelah restart | ✅ Permanen |
| Testability | Sulit di-test | Mudah di-test (logic terpisah) |

### Alasan Pemilihan Teknologi

#### Riverpod
- **Compile-safe**: Error terdeteksi saat compile, bukan runtime
- **Tidak butuh BuildContext**: Provider bisa diakses dari mana saja
- **Reactive**: UI otomatis update saat data berubah
- **Testable**: Mudah di-mock untuk unit testing

#### Hive
- **Sangat cepat**: 5-10x lebih cepat dari SharedPreferences untuk data kompleks
- **Type-safe**: Dengan TypeAdapter, data tersimpan native (bukan JSON string)
- **NoSQL**: Fleksibel untuk object kompleks seperti Habit
- **Offline-first**: Bekerja tanpa koneksi internet

---

## Detail Teknis

### Struktur Model Habit (dengan Hive Annotations)

```dart
@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  final String id;           // ID unik
  
  @HiveField(1)
  final String title;        // Judul habit
  
  @HiveField(2)
  final String subtitle;     // Deskripsi singkat
  
  @HiveField(3)
  final String time;         // Waktu (format: "9:00 AM")
  
  @HiveField(4)
  final String repeat;       // 'Daily', 'Weekly', 'Specific Days'
  
  @HiveField(5)
  final DateTime startDate;  // Tanggal mulai
  
  @HiveField(6)
  final DateTime? endDate;   // Tanggal berakhir (opsional)
  
  @HiveField(7)
  String status;             // 'pending' atau 'completed'
  
  @HiveField(8)
  final List<bool>? specificDays; // Hari spesifik (index 0-6)
}
```

### Riverpod Providers

```dart
// Provider utama untuk habit state
final habitProvider = StateNotifierProvider<HabitNotifier, HabitState>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return HabitNotifier(repository);
});

// Provider untuk tanggal yang dipilih
final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

// Provider untuk habits yang sudah difilter
final filteredHabitsProvider = Provider<List<Habit>>((ref) {
  final state = ref.watch(habitProvider);
  final selectedDate = ref.watch(selectedDateProvider);
  // ... filter & sort logic
  return filtered;
});

// Provider untuk cek semua habit selesai
final allHabitsCompletedProvider = Provider<bool>((ref) {
  final filtered = ref.watch(filteredHabitsProvider);
  return filtered.isNotEmpty && filtered.every((h) => h.isCompleted);
});
```

### StateNotifier (HabitNotifier)

```dart
class HabitNotifier extends StateNotifier<HabitState> {
  final HabitRepository _repository;
  
  // Methods yang bisa dipanggil dari UI:
  Future<void> loadHabits() async { ... }
  Future<void> addHabit(Habit habit) async { ... }
  Future<void> updateHabit(Habit habit) async { ... }
  Future<void> deleteHabit(String id) async { ... }
  Future<void> toggleHabitStatus(String id) async { ... }
}
```

### Penggunaan di UI (ConsumerStatefulWidget)

```dart
class HomePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    // WATCH: Listen perubahan data (reactive)
    final habitState = ref.watch(habitProvider);
    final filteredHabits = ref.watch(filteredHabitsProvider);
    
    // Loading state
    if (habitState.isLoading) {
      return CircularProgressIndicator();
    }
    
    // ... build UI
  }
  
  void _addHabit(Habit habit) {
    // READ: Trigger action (tidak listen)
    ref.read(habitProvider.notifier).addHabit(habit);
  }
}
```

### Inisialisasi Hive (main.dart)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Initialize Hive
  await Hive.initFlutter();
  
  // 2. Register TypeAdapter
  Hive.registerAdapter(HabitAdapter());
  
  // 3. Open Box
  await Hive.openBox<Habit>('habits');
  
  // 4. Run app dengan ProviderScope
  runApp(const ProviderScope(child: MyApp()));
}
```

### Routing (Named Routes)

| Route | Halaman |
|-------|---------|
| `/` | WelcomePage |
| `/login` | LoginPage |
| `/register` | RegisterPage |
| `/home` | HomePage |
| `/profile` | ProfilePage |

### Logika Filter Habit

```
1. Cek tanggal dalam range (startDate - endDate)
2. Cek tipe repeat:
   - Daily → selalu tampil
   - Specific Days → cek array specificDays[weekday]
3. Sort: pending dulu, lalu by waktu
```

### Lifecycle dengan Riverpod

```
┌──────────────────────────────────────────────────────┐
│                    APP START                          │
└────────────────────────┬─────────────────────────────┘
                         ▼
┌──────────────────────────────────────────────────────┐
│  main() → Hive.initFlutter() → registerAdapter()    │
│         → openBox() → ProviderScope(child: MyApp()) │
└────────────────────────┬─────────────────────────────┘
                         ▼
┌──────────────────────────────────────────────────────┐
│  HabitNotifier created → loadHabits() from Hive     │
└────────────────────────┬─────────────────────────────┘
                         ▼
┌──────────────────────────────────────────────────────┐
│  UI: ref.watch(habitProvider) → Render list         │
└────────────────────────┬─────────────────────────────┘
                         ▼
┌──────────────────────────────────────────────────────┐
│  User action → ref.read(notifier).method()          │
│             → Repository.save() → Hive Box          │
│             → state update → UI rebuild (reactive)  │
└──────────────────────────────────────────────────────┘
```

---

## 📱 Alur Aplikasi (User Flow)

```
┌─────────────┐
│  Welcome    │
│    Page     │
└──────┬──────┘
       │
   ┌───┴───┐
   ▼       ▼
┌──────┐ ┌──────────┐
│Login │ │ Register │
└──┬───┘ └────┬─────┘
   │          │
   └────┬─────┘
        ▼
   ┌─────────┐
   │  Home   │ ←─── Tambah Habit (auto-save ke Hive)
   │  Page   │ ←─── Edit Habit (auto-save ke Hive)
   └────┬────┘ ←─── Hapus Habit (dengan konfirmasi)
        │
        ▼
   ┌─────────┐
   │ Profile │ → Logout → Welcome Page
   │  Page   │
   └─────────┘
```

---

## 📚 Kesimpulan

### Pembelajaran dari Refactoring

1. **Separation of Concerns**: Memisahkan UI dari business logic membuat kode lebih mudah di-maintain
2. **Riverpod**: State management yang type-safe dan reactive
3. **Hive**: Database NoSQL yang cepat dan efisien untuk mobile
4. **Clean Architecture**: Struktur folder yang modular dan scalable

### Hasil Akhir

Aplikasi HabitLy berhasil di-refactor dengan:
- ✅ Data persistence yang benar (tidak hilang setelah restart)
- ✅ Kode yang lebih bersih dan terstruktur
- ✅ UI reaktif yang otomatis update saat data berubah
- ✅ Performa lebih baik dengan Hive NoSQL