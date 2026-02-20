# 🌿 HabitLy - Daftar Kebiasaan

<p align="center">
  <img src="assets/images/icon-habitly.png" alt="HabitLy Logo" width="150"/>
</p>

<p align="center">
  <strong>Aplikasi pelacak kebiasaan (habit tracker) untuk membangun rutinitas positif.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.10.3-blue?logo=flutter" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart" alt="Dart"/>
</p>

---

## 📖 Deskripsi

**HabitLy** adalah aplikasi Flutter untuk membantu pengguna membangun dan melacak kebiasaan sehari-hari. Aplikasi ini dirancang dengan antarmuka yang modern, bersih, dan intuitif untuk memberikan pengalaman pengguna yang menyenangkan.

## ✨ Fitur Utama

| Fitur | Deskripsi |
|-------|-----------|
| 🔐 **Autentikasi** | Sistem login & register dengan penyimpanan lokal |
| 📅 **Kalender Interaktif** | Strip kalender mingguan untuk navigasi tanggal |
| ✅ **Manajemen Habit** | Tambah, edit, hapus, dan tandai habit sebagai selesai |
| 📊 **Progress Tracking** | Progress bar harian dengan persentase |
| 🎉 **Celebrasi** | Efek confetti saat semua task hari itu selesai |
| 👤 **Profil Pengguna** | Halaman profil dengan edit nama & email |
| 🗂️ **Data Per-User** | Setiap akun memiliki daftar habit terpisah |
| 🗑️ **Konfirmasi Hapus** | Alert dialog sebelum menghapus habit |

## 🛠️ Teknologi

- **Framework**: [Flutter](https://flutter.dev/) 3.10.3
- **State Management**: [Riverpod](https://riverpod.dev/) (StateNotifierProvider)
- **Database Lokal**: [Hive](https://docs.hivedb.dev/) (NoSQL)
- **Penyimpanan User**: SharedPreferences
- **Font**: Google Fonts (Urbanist)
- **Animasi**: Confetti, AnimatedContainer

## 📁 Struktur Proyek

```
lib/
├── main.dart                    # Entry point + Hive init + ProviderScope
├── core/                        # Fondasi & Konfigurasi
│   ├── constants/
│   │   ├── colors.dart          # Konstanta warna
│   │   └── text_styles.dart     # Konstanta TextStyle
│   └── theme/
│       └── app_theme.dart       # ThemeData terpusat
├── data/                        # Data Layer
│   ├── models/
│   │   ├── habit_model.dart     # Model Habit + Hive annotations
│   │   └── habit_model.g.dart   # Generated TypeAdapter
│   ├── repositories/
│   │   └── habit_repository.dart # CRUD operations dengan Hive
│   └── services/
│       └── habit_service.dart   # Legacy service (deprecated)
├── providers/                   # Provider Layer (Riverpod)
│   └── habit_provider.dart      # StateNotifier + Providers
├── pages/                       # Halaman Utama
│   ├── welcome_page.dart        # Halaman Sambutan
│   ├── login_page.dart          # Halaman Login
│   ├── register_page.dart       # Halaman Registrasi
│   ├── home_page.dart           # Halaman Utama (ConsumerStatefulWidget)
│   └── profile_page.dart        # Halaman Profil
└── widgets/                     # Komponen Reusable
    ├── add_habit_modal.dart     # Modal Tambah/Edit Habit
    ├── celebration_dialog.dart  # Dialog Selebrasi
    └── home/
        ├── hero_card.dart       # Card Progress
        ├── calendar_strip.dart  # Strip Kalender
        ├── habit_item.dart      # Item Habit + Delete Confirmation
        └── empty_state.dart     # Empty State
```

## 🚀 Cara Menjalankan

### Prasyarat

- Flutter SDK >= 3.10.3
- Dart SDK >= 3.0.0
- Android Studio / VS Code
- Emulator atau perangkat fisik

### Instalasi

1. **Clone repository**
   ```bash
   git clone https://github.com/fajri-playground/mission_7b_riverpod_firebase_war.git
   cd mission_7b_riverpod_firebase_war
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi**
   ```bash
   flutter run
   ```

## 🔐 Akun Demo

Gunakan akun demo berikut untuk testing tanpa registrasi:

| Field | Value |
|-------|-------|
| **Email** | `user@example.com` |
| **Password** | `User123` |

> **Note:** Jika belum ada akun tersimpan, aplikasi akan otomatis membuat akun demo saat login dengan kredensial di atas.

## 🎨 Color Palette

| Warna | Hex | Penggunaan |
|-------|-----|------------|
| Primary | `#2FB969` | Tombol, highlight, accent |
| Primary Dark | `#23A158` | Gradient, shadow |
| Background | `#E3FFDB` | Latar belakang halaman |
| Surface | `#FFFFFF` | Card, modal, input |

## 📄 Halaman Aplikasi

| Halaman | Deskripsi |
|---------|-----------|
| **Welcome** | Halaman pembuka dengan navigasi ke login/register |
| **Login & Register** | Form autentikasi dengan validasi input |
| **Home** | Header progress, kalender strip, daftar habit |
| **Profile** | Informasi user, edit profil, logout |

## 📚 Dokumentasi

Untuk dokumentasi teknis lengkap, lihat: **[docs/REPORT.md](docs/REPORT.md)**

Isi dokumentasi:
- Pendahuluan & tujuan proyek
- Detail fitur aplikasi
- Arsitektur & struktur kode
- Detail teknis (model, routing, lifecycle)
- Alur aplikasi (user flow)

## 🤝 Kontribusi

Kontribusi sangat diterima! Silakan buat *Pull Request* atau buka *Issue* jika ada bug atau ide pengembangan.
