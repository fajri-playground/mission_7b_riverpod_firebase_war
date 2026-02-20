import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller untuk mengambil input text
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // Status state untuk Flow Login Opsi 1
  bool _isPasswordVisible = false; // Menandakan apakah tahap input password sudah aktif
  bool _isObscure = true; // Menandakan apakah text password disembunyikan

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mendapatkan ukuran layar untuk keperluan layout responsif
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFE3FFDB), // Mengatur warna background (Hijau Muda HabitLy)
      body: SafeArea(
        bottom: false, // Membiarkan bottom bar menyentuh bagian paling bawah layar
        child: Column(
          children: [
            // Konten Utama
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // BAGIAN 1: Logo & Judul Aplikasi
                      Image.asset(
                        'assets/images/icon-habitly.png',
                        width: 150, 
                        fit: BoxFit.contain,
                      ),
                      
                      const SizedBox(height: 20),

                      // BAGIAN 2: Tautan ke Halaman Register
                      Text(
                        "Didn't have account ?",
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text(
                          "Create one here!",
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // BAGIAN 3: Form Input Email
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _emailController,
                            // Jika password sudah muncul, email jadi read-only agar user fokus ke password
                            // (Atau bisa dibiarkan editable jika ingin revisi, di sini saya biarkan editable)
                            decoration: InputDecoration(
                              hintText: 'email@domain.com',
                              hintStyle: GoogleFonts.urbanist(color: Colors.grey[400]),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              // Icon surat opsional, tapi agar bersih sesuai desain kita biarkan polos
                            ),
                          ),
                        ),
                      ),

                      // ANIMASI: Kolom Password Muncul (Expandable)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        height: _isPasswordVisible ? 70 : 0, // 0 = Tersembunyi, 70 = Muncul (tinggi container + margin)
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              const SizedBox(height: 20), // Margin atas
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: TextField(
                                    controller: _passwordController,
                                    obscureText: _isObscure, // Gunakan state variable
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      hintStyle: GoogleFonts.urbanist(color: Colors.grey[400]),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                      // Icon mata untuk show/hide password
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _isObscure ? Icons.visibility_off : Icons.visibility,
                                          color: Colors.grey[400],
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isObscure = !_isObscure;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // BAGIAN 4: Tombol Utama (Berubah Fungsi: Continue -> Login)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              // LOGIKA LOGIN (Dual: Hardcoded & Local Storage)
                              
                              // Ambil data dari Shared Preferences
                              final prefs = await SharedPreferences.getInstance();
                              final registeredEmail = prefs.getString('user_email');
                              final registeredPassword = prefs.getString('user_password');

                              if (!_isPasswordVisible) {
                                // TAHAP 1: Cek Email
                                final email = _emailController.text.trim();
                                final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

                                if (email.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Please enter your email')),
                                  );
                                } else if (!emailRegex.hasMatch(email)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Invalid email format!'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } else if (email == 'user@example.com' || (registeredEmail != null && email == registeredEmail)) {
                                  // Case 1: Akun Demo
                                  // Case 2: Akun Real (Registered Local)
                                  setState(() {
                                    _isPasswordVisible = true; // Munculkan kolom password
                                  });
                                } else {
                                  // Email tidak ditemukan di keduanya
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Email not registered! (Try: user@example.com or Register new)'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } else {
                                // TAHAP 2: Login Sebenarnya (Validasi Password)
                                final enteredPassword = _passwordController.text;
                                final inputEmail = _emailController.text.trim();

                                bool isLoginSuccess = false;

                                // Cek Pake Akun Demo
                                if (inputEmail == 'user@example.com' && enteredPassword == 'User123') {
                                  isLoginSuccess = true;
                                  
                                  // SIMPAN DATA DUMMY LENGKAP KE SHARED PREF
                                  // Agar saat masuk Home, datanya lengkap (Nama, HP, dll)
                                  await prefs.setString('user_fullname', 'Demo User Habitly');
                                  await prefs.setString('user_email', 'user@example.com');
                                  await prefs.setString('user_phone', '081299998888');
                                  await prefs.setString('user_gender', 'Male');
                                  await prefs.setString('user_password', 'User123');
                                }
                                // Cek Pake Akun Lokal (Hasil Register)
                                else if (registeredEmail != null && inputEmail == registeredEmail && enteredPassword == registeredPassword) {
                                  isLoginSuccess = true;
                                  // Tidak perlu simpan ulang, karena data sudah ada saat register
                                }

                                if (isLoginSuccess) {
                                  // Feedback Login Sukses
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Login Successful! Welcome back.'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );

                                  // Jeda sedikit agar user membaca pesan sukses
                                  Future.delayed(const Duration(milliseconds: 1500), () {
                                    if (context.mounted) {
                                      Navigator.pushReplacementNamed(context, '/home');
                                    }
                                  });
                                } else {
                                  // Password Salah
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Invalid Password!'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            // Teks tombol berubah dinamis
                            child: Text(
                              _isPasswordVisible ? 'Login' : 'Continue',
                              style: GoogleFonts.urbanist(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // BAGIAN 5: Divider Pemisah "or"
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'or',
                                style: GoogleFonts.urbanist(
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // BAGIAN 6: Tombol Login Sosial Media (Google & Apple)
                      // Tombol Login Google
                      _buildSocialButton(
                        iconPath: 'assets/images/google.svg',
                        text: 'Continue with Google',
                        onTap: () {},
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Tombol Login Apple
                      _buildSocialButton(
                        iconPath: 'assets/images/apple.svg',
                        text: 'Continue with Apple',
                        iconColor: Colors.black, 
                        onTap: () {},
                      ),

                      const SizedBox(height: 40),

                      // BAGIAN 7: Footer (Syarat & Ketentuan)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: GoogleFonts.urbanist(
                              fontSize: 12,
                              color: Colors.grey[600],
                              height: 1.5,
                            ),
                            children: [
                              const TextSpan(text: 'By clicking continue, you agree to our '),
                              TextSpan(
                                text: 'Terms of Service\n',
                                style: GoogleFonts.urbanist(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const TextSpan(text: 'and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: GoogleFonts.urbanist(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            
            // BAGIAN 8: Dekorasi Bar Hijau Bawah
            Container(
              width: size.width * 0.9,
              height: 28,
              decoration: const BoxDecoration(
                color: Color(0xFF2FB969), // Hijau HabitLy
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET HELPER: Untuk membuat tombol login sosial (reusable)
  Widget _buildSocialButton({
    required String iconPath,
    required String text,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2), // Latar abu-abu muda
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               SvgPicture.asset(
                 iconPath,
                 width: 24,
                 height: 24,
                 // Jika iconColor diberikan, terapkan filter warna (berguna untuk icon Apple)
                 colorFilter: iconColor != null 
                    ? ColorFilter.mode(iconColor, BlendMode.srcIn) 
                    : null,
               ),
               const SizedBox(width: 12),
               Text(
                 text,
                 style: GoogleFonts.urbanist(
                   fontSize: 14,
                   fontWeight: FontWeight.w600,
                   color: Colors.black,
                 ),
               ),
            ],
          ),
        ),
      ),
    );
  }
}
