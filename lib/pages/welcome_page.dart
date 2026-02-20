import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mendapatkan ukuran layar untuk layout yang responsif
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFE3FFDB), // Warna Background Hijau Muda
      body: Column(
        children: [
          // BAGIAN ATAS: Logo HabitLy
          // Menggunakan Expanded dengan flex 3 agar mengambil porsi atas layar
          Expanded(
            flex: 3,
            child: Align(
              // Menyesuaikan posisi logo: (0.0, 0.2) = Horizontal tengah, Vertikal agak turun
              alignment: const Alignment(0.0, 0.2),
              child: Image.asset(
                'assets/images/icon-habitly.png',
                width: 150, 
                fit: BoxFit.contain,
              ),
            ),
          ),
          
          // BAGIAN BAWAH: Kartu Putih & Konten
          // Menggunakan Expanded dengan flex 2 (total rasio 3:2 dengan bagian atas)
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                // Membuat sudut atas kiri & kanan melengkung (Rounded)
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  // Konten Tengah (Text & Tombol Panah)
                  // Menggunakan Expanded agar konten ini berada di tengah area putih yang tersisa
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Keep up your Health!',
                          style: GoogleFonts.urbanist(
                            fontSize: 24,
                            fontWeight: FontWeight.w500, // Ketebalan Font Medium
                            color: Colors.black87,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 20), // Jarak antara teks dan tombol
                        
                        // Tombol Panah untuk Navigasi
                        GestureDetector(
                          onTap: () {
                            // Pindah ke halaman Login menggunakan Named Route
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Image.asset(
                            'assets/images/arrow-right-circle.png',
                            width: 60,
                            height: 60,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Bar Hijau Dekoratif di Bawah
                  Container(
                    width: size.width * 0.9, // Lebar 80% dari layar
                    height: 28, 
                    decoration: const BoxDecoration(
                      color: Color(0xFF2FB969), // Warna Hijau HabitLy
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
