import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controller untuk input text
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // State untuk Jenis Kelamin (Dropdown)
  String? _selectedGender;
  
  // State untuk Visibility Password
  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ukuran layar untuk referensi layout
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFE3FFDB), // Background Hijau Muda
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Konten Utama dengan Scroll View
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      
                      // 1. Logo & Judul
                      Image.asset(
                        'assets/images/icon-habitly.png',
                        width: 120, // Sedikit lebih kecil agar muat
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 10),

                      // 2. Link Balik ke Login
                      Text(
                        "Already have an account ?",
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: Text(
                          "Login here!",
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                            // decoration: TextDecoration.underline, // Dihapus sesuai request
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // ================== FORM INPUT ==================
                      
                      // A. Nama Lengkap
                      _buildTextField(
                        controller: _fullNameController,
                        hintText: 'Full Name',
                      ),
                      const SizedBox(height: 12),

                      // B. Email
                      _buildTextField(
                        controller: _emailController,
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),

                      // C. Jenis Kelamin (Dropdown)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedGender,
                            hint: Text(
                              'Select Gender',
                              style: GoogleFonts.urbanist(
                                color: Colors.grey[400],
                                fontSize: 16,
                              ),
                            ),
                            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
                            iconSize: 24,
                            isExpanded: true,
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            items: ['Male', 'Female'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: GoogleFonts.urbanist(fontSize: 16)),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedGender = newValue;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // D. Nomor Telepon (+62 Prefix)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center, // Pastikan sejajar vertikal
                          children: [
                            // Prefix +62 Manual (Bukan prefixIcon)
                            Padding(
                              padding: const EdgeInsets.only(left: 16, right: 8),
                              child: Text(
                                '+62',
                                style: GoogleFonts.urbanist(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            // Input Field
                            Expanded(
                              child: TextField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  hintText: '812-3456-7890',
                                  hintStyle: GoogleFonts.urbanist(color: Colors.grey[400]),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 14), // Horizontal 0 karena sudah diatur Row
                                  isDense: true, 
                                ),
                              ),
                            ),
                            const SizedBox(width: 16), // Padding kanan
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // E. Kata Sandi
                      _buildTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        obscureText: _isPasswordObscure, // Gunakan state yang sama/sinkron
                        onSuffixTap: () {
                          setState(() {
                            // Toggle keduanya agar selaras
                            _isPasswordObscure = !_isPasswordObscure;
                            _isConfirmPasswordObscure = _isPasswordObscure; // Sinkronkan
                          });
                        },
                      ),
                      const SizedBox(height: 12),

                      // F. Konfirmasi Kata Sandi
                      _buildTextField(
                        controller: _confirmPasswordController,
                        hintText: 'Confirm Password',
                        obscureText: _isConfirmPasswordObscure, // Gunakan state sinkron
                        onSuffixTap: () {
                          setState(() {
                             // Toggle keduanya agar selaras
                             _isConfirmPasswordObscure = !_isConfirmPasswordObscure;
                             _isPasswordObscure = _isConfirmPasswordObscure; // Sinkronkan
                          });
                        },
                      ),

                      const SizedBox(height: 25),

                      // 4. Tombol Register (Hitam)
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // --- VALIDASI REGISTER ---

                            // 1. Ambil Value dari Controller
                            final fullName = _fullNameController.text.trim();
                            final email = _emailController.text.trim();
                            final phone = _phoneController.text.trim();
                            final gender = _selectedGender;
                            final password = _passwordController.text;
                            final confirmPassword = _confirmPasswordController.text;

                            // 2. Cek Kelengkapan Data
                            if (fullName.isEmpty || email.isEmpty || phone.isEmpty || gender == null || password.isEmpty || confirmPassword.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please fill in all fields!'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            // 3. Validasi Format Email
                            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                            if (!emailRegex.hasMatch(email)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Invalid email format!'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            // 4. Validasi Nomor Telepon (Min 8 digit, Angka saja)
                            final phoneRegex = RegExp(r'^[0-9]+$');
                            if (!phoneRegex.hasMatch(phone) || phone.length < 8) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Phone number must be at least 8 digits using only numbers!'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            // 5. Validasi Kekuatan Password
                            // Min 6 char, 1 Uppercase, 1 Special Char
                            final passwordStrengthRegex = RegExp(r'^(?=.*[A-Z])(?=.*[^a-zA-Z0-9]).{6,}$');
                            if (!passwordStrengthRegex.hasMatch(password)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Password must have min 6 chars, 1 Uppercase, and 1 Special Character!'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 4), // Tampil lebih lama agar user sempat baca
                                ),
                              );
                              return;
                            }

                            // 6. Validasi Konfirmasi Password
                            if (password != confirmPassword) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Password and Confirm Password do not match!'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            // --- JIKA SEMUA VALID ---
                            
                            // SIMPAN DATA KE SHARED PREFERENCES (Lokal)
                            _saveUserData(
                              fullName: fullName, 
                              email: email, 
                              password: password,
                              phone: phone,
                              gender: gender,
                            ).then((_) {
                               // Jika simpan berhasil
                               if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Registration Successful! Data saved locally. Please Login.'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );

                                  // Redirect ke Halaman Login setelah 1.5 detik
                                  Future.delayed(const Duration(milliseconds: 1500), () {
                                    if (context.mounted) {
                                      Navigator.pushReplacementNamed(context, '/login');
                                    }
                                  });
                               }
                            });

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Register',
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 5. Divider "or"
                      Row(
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

                      const SizedBox(height: 20),

                      // 6. Social Buttons (Google & Apple)
                      _buildSocialButton(
                        iconPath: 'assets/images/google.svg',
                        text: 'Continue with Google',
                        onTap: () {},
                      ),
                      const SizedBox(height: 12),
                      _buildSocialButton(
                        iconPath: 'assets/images/apple.svg',
                        text: 'Continue with Apple',
                        iconColor: Colors.black,
                        onTap: () {},
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
            
            // 7. Bottom Green Bar (Fixed at bottom)
            Container(
              width: size.width * 0.9,
              height: 28,
              decoration: const BoxDecoration(
                color: Color(0xFF2FB969),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- LOGIC SIMPAN DATA ---
  Future<void> _saveUserData({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required String gender,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Simpan data dengan Key tertentu
    await prefs.setString('user_fullname', fullName);
    await prefs.setString('user_email', email);
    await prefs.setString('user_password', password);
    await prefs.setString('user_phone', phone);
    await prefs.setString('user_gender', gender);
    
    print("Data Registered: $email / $password"); // Debug log
  }

  // Helper Widget: Custom TextField (Reusable)
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    VoidCallback? onSuffixTap,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.urbanist(color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          // Suffix Icon (mata) jika onSuffixTap diberikan
          suffixIcon: onSuffixTap != null
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey[400],
                  ),
                  onPressed: onSuffixTap,
                )
              : null,
        ),
      ),
    );
  }

  // Helper Widget: Social Button (Reusable)
  Widget _buildSocialButton({
    required String iconPath,
    required String text,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             SvgPicture.asset(
               iconPath,
               width: 24,
               height: 24,
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
    );
  }
}
