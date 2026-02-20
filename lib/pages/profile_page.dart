import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/add_habit_modal.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // State User Data
  String _fullName = '';
  String _email = '';
  String _phone = '';
  String _password = ''; // Disimpan untuk validasi ganti password
  
  List<Map<String, dynamic>> _myHabits = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadHabitList();
  }

  /// Memuat data user dari Shared Preferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName = prefs.getString('user_fullname') ?? 'Guest User';
      _email = prefs.getString('user_email') ?? 'guest@habitly.com';
      _phone = prefs.getString('user_phone') ?? '-';
      _password = prefs.getString('user_password') ?? '';
    });
  }

  /// Memuat Data Habit
  Future<void> _loadHabitList() async {
    final prefs = await SharedPreferences.getInstance();
    final String? habitsJson = prefs.getString('my_habits');
    if (habitsJson != null) {
      setState(() {
        _myHabits = List<Map<String, dynamic>>.from(jsonDecode(habitsJson));
      });
    }
  }

  /// Menyimpan Data Habit
  Future<void> _saveHabitList() async {
    final prefs = await SharedPreferences.getInstance();
    final String habitsJson = jsonEncode(_myHabits);
    await prefs.setString('my_habits', habitsJson);
  }

  /// Logout Logic
  Future<void> _handleLogout() async {
    // Tampilkan konfirmasi
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Logout", style: GoogleFonts.urbanist(fontWeight: FontWeight.bold)),
        content: Text("Are you sure you want to logout?", style: GoogleFonts.urbanist()),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: GoogleFonts.urbanist(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Tutup dialog
              
              // Clear Session (Opsional: Hapus semua atau cuma isLogin)
              // Di sini kita biarkan data tersimpan tapi redirect ke Login
              
              if (mounted) {
                 Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              }
            },
            child: Text("Logout", style: GoogleFonts.urbanist(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3FFDB),
      
      // BODY
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER PROFILE (Hijau Gelap dengan Avatar)
            Container(
              padding: const EdgeInsets.only(top: 60, bottom: 30),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF2FB969), // Primary Green
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // Judul Halaman
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Center(
                      child: Text(
                        "My Profile",
                        style: GoogleFonts.urbanist(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Avatar Besar
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: Center(
                      child: Text(
                        _fullName.isNotEmpty ? _fullName[0].toUpperCase() : "U",
                        style: GoogleFonts.urbanist(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2FB969),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Nama & Email
                  Text(
                    _fullName,
                    style: GoogleFonts.urbanist(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _email,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),

            // MENU OPTIONS LIST
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Bagian: Akun
                  _buildSectionTitle("Account Settings"),
                  _buildMenuTile(
                    icon: Icons.edit,
                    title: "Edit Profile",
                    subtitle: "Update name, phone, etc.",
                    onTap: () => _showEditProfileModal(context),
                  ),
                  _buildMenuTile(
                    icon: Icons.lock,
                    title: "Change Password",
                    subtitle: "Secure your account",
                    onTap: () => _showChangePasswordModal(context),
                  ),

                  const SizedBox(height: 24),
                  
                  // Bagian: Umum
                  _buildSectionTitle("General"),
                  _buildMenuTile(
                    icon: Icons.info_outline,
                    title: "About HabitLy",
                    subtitle: "Version 1.0.0",
                    onTap: () {
                      // Custom Dialog tanpa tombol Licenses
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          title: Row(
                            children: [
                              const Icon(Icons.check_circle, color: Color(0xFF2FB969), size: 30),
                              const SizedBox(width: 12),
                              Text("About HabitLy", style: GoogleFonts.urbanist(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("HabitLy helps you build better habits.", style: GoogleFonts.urbanist()),
                              const SizedBox(height: 16),
                              Text("Created by", style: GoogleFonts.urbanist(color: Colors.grey)),
                              Text("Fajri Farid", style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                              const SizedBox(height: 8),
                              Text("Version 1.0.0", style: GoogleFonts.urbanist(color: Colors.grey[400], fontSize: 12)),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Close", style: GoogleFonts.urbanist(color: const Color(0xFF2FB969), fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  _buildMenuTile(
                    icon: Icons.logout,
                    title: "Logout",
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    hideArrow: true,
                    onTap: _handleLogout,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          onPressed: () {
            _showAddHabitModal(context);
          },
          backgroundColor: const Color(0xFF2FB969),
          shape: const CircleBorder(),
          elevation: 4,
          child: const Icon(Icons.add, color: Colors.white, size: 40),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 12.0,
        color: Colors.white,
        child: SizedBox(
          height: 70.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // Tombol Home
              IconButton(
                icon: const Icon(Icons.home_outlined, size: 30),
                color: Colors.grey[400],
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
              ),
              const SizedBox(width: 48), // Spasi untuk FAB

              // Tombol Profile
              IconButton(
                icon: const Icon(Icons.person, size: 30),
                color: const Color(0xFF2FB969),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- MODAL: TAMBAH HABIT ---
  void _showAddHabitModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AddHabitModal(
          onHabitCreated: (newHabit) {
            setState(() {
              _myHabits.add(newHabit);
            });
            _saveHabitList();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Habit Created & Saved!'),
                backgroundColor: Colors.green
              ),
            );
          },
        );
      },
    );
  }

  // --- MODAL: EDIT PROFIL ---
  void _showEditProfileModal(BuildContext parentContext) {
    final nameController = TextEditingController(text: _fullName);
    final phoneController = TextEditingController(text: _phone);
    
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(modalContext).viewInsets.bottom,
          top: 24, left: 24, right: 24
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
             const SizedBox(height: 20),
             Text("Edit Profile", style: GoogleFonts.urbanist(fontSize: 20, fontWeight: FontWeight.bold)),
             const SizedBox(height: 24),
             
             // 1. Full Name Section
             Text("Full Name", style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[600])),
             const SizedBox(height: 8),
             _buildTextField(controller: nameController, hint: "Enter your full name"),
             const SizedBox(height: 20),
             
             // 2. Phone Section
             Text("Phone Number", style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[600])),
             const SizedBox(height: 8),
             _buildTextField(controller: phoneController, hint: "Enter your phone number", keyboardType: TextInputType.phone),
             
             const SizedBox(height: 30),
             SizedBox(
               width: double.infinity,
               height: 50,
               child: ElevatedButton(
                 onPressed: () async {
                    // 1. Validasi Input Kosong
                    if (nameController.text.trim().isEmpty || phoneController.text.trim().isEmpty) {
                       ScaffoldMessenger.of(parentContext).showSnackBar(
                        const SnackBar(content: Text("Field cannot be empty!"), backgroundColor: Colors.red),
                      );
                      return;
                    }

                    // 2. Validasi Phone (Angka saja, min 8)
                    final phoneRegex = RegExp(r'^[0-9]+$');
                    if (!phoneRegex.hasMatch(phoneController.text) || phoneController.text.length < 8) {
                       ScaffoldMessenger.of(parentContext).showSnackBar(
                        const SnackBar(content: Text("Phone must be number & min 8 digits!"), backgroundColor: Colors.red),
                      );
                      return;
                    }

                    // Simpan Perubahan
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('user_fullname', nameController.text.trim());
                    await prefs.setString('user_phone', phoneController.text.trim());
                    
                    if (mounted) {
                      setState(() {
                        _fullName = nameController.text.trim();
                        _phone = phoneController.text.trim();
                      });
                      Navigator.pop(modalContext); // Pop Modal Context
                      ScaffoldMessenger.of(parentContext).showSnackBar( // Use Parent Context
                        const SnackBar(content: Text("Profile Updated!"), backgroundColor: Colors.green),
                      );
                    }
                 },
                 style: ElevatedButton.styleFrom(
                   backgroundColor: const Color(0xFF2FB969),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                 ),
                 child: Text("Save Changes", style: GoogleFonts.urbanist(color: Colors.white, fontWeight: FontWeight.bold)),
               ),
             ),
             const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- MODAL: GANTI PASSWORD ---
  void _showChangePasswordModal(BuildContext parentContext) {
    final oldPassController = TextEditingController();
    final newPassController = TextEditingController();
    final confirmPassController = TextEditingController();
    
    // State lokal untuk visibility password dalam modal
    bool obscureOld = true;
    bool obscureNew = true;
    bool obscureConfirm = true;

    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        // StatefulBuilder agar bisa update icon mata tanpa close modal
        return StatefulBuilder(
          builder: (sbContext, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(modalContext).viewInsets.bottom,
                top: 24, left: 24, right: 24
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
                     const SizedBox(height: 20),
                     Text("Change Password", style: GoogleFonts.urbanist(fontSize: 20, fontWeight: FontWeight.bold)),
                     const SizedBox(height: 24),
                     
                     // 1. Label Section Layout
                     Text("Current Password", style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[600])),
                     const SizedBox(height: 8),
                     _buildTextField(
                       controller: oldPassController, 
                       hint: "Enter your current password",
                       obscureText: obscureOld,
                       onSuffixTap: () {
                         setModalState(() => obscureOld = !obscureOld);
                       }
                     ),
                     const SizedBox(height: 20),
                     
                     Text("New Password", style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[600])),
                     const SizedBox(height: 8),
                     _buildTextField(
                       controller: newPassController, 
                       hint: "Enter new password",
                       obscureText: obscureNew,
                       onSuffixTap: () {
                         setModalState(() {
                           obscureNew = !obscureNew;
                           obscureConfirm = obscureNew; // Sinkronkan
                         });
                       }
                     ),
                     const SizedBox(height: 12),

                     _buildTextField(
                       controller: confirmPassController, 
                       hint: "Confirm new password",
                       obscureText: obscureConfirm,
                       onSuffixTap: () {
                         setModalState(() {
                           obscureConfirm = !obscureConfirm;
                           obscureNew = obscureConfirm; // Sinkronkan
                         });
                       }
                     ),

                     const SizedBox(height: 30),
                     SizedBox(
                       width: double.infinity,
                       height: 50,
                       child: ElevatedButton(
                         onPressed: () async {
                            final oldPass = oldPassController.text;
                            final newPass = newPassController.text;
                            final confirmPass = confirmPassController.text;

                            // A. Validasi Password Lama
                            if (oldPass != _password) {
                               ScaffoldMessenger.of(parentContext).showSnackBar(
                                const SnackBar(content: Text("Wrong Current Password!"), backgroundColor: Colors.red),
                              );
                              return;
                            }

                            // B. Validasi Field Kosong
                            if (newPass.isEmpty || confirmPass.isEmpty) {
                               ScaffoldMessenger.of(parentContext).showSnackBar(
                                const SnackBar(content: Text("Please fill all fields!"), backgroundColor: Colors.red),
                              );
                              return;
                            }

                            // C. Validasi Kekuatan Password
                            final passwordStrengthRegex = RegExp(r'^(?=.*[A-Z])(?=.*[^a-zA-Z0-9]).{6,}$');
                            if (!passwordStrengthRegex.hasMatch(newPass)) {
                              ScaffoldMessenger.of(parentContext).showSnackBar(
                                const SnackBar(
                                  content: Text('Password must have min 6 chars, 1 Uppercase, and 1 Special Character!'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 3),
                                ),
                              );
                              return;
                            }
                            
                            // D. Validasi Match
                            if (newPass != confirmPass) {
                               ScaffoldMessenger.of(parentContext).showSnackBar(
                                const SnackBar(content: Text("New Passwords do not match!"), backgroundColor: Colors.red),
                              );
                              return;
                            }

                            // E. Simpan
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString('user_password', newPass);
                            
                            if (mounted) {
                              setState(() {
                                _password = newPass;
                              });
                              Navigator.pop(modalContext);
                              ScaffoldMessenger.of(parentContext).showSnackBar(
                                const SnackBar(content: Text("Password Changed Successfully!"), backgroundColor: Colors.green),
                              );
                            }
                         },
                         style: ElevatedButton.styleFrom(
                           backgroundColor: const Color(0xFF2FB969),
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                         ),
                         child: Text("Update Password", style: GoogleFonts.urbanist(color: Colors.white, fontWeight: FontWeight.bold)),
               ),
             ),
             const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
        );
      },
    );
  }

  // Widget Bantuan UI
  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.urbanist(
          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon, 
    required String title, 
    String? subtitle,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFF2FB969),
    Color textColor = Colors.black87,
    bool hideArrow = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        title: Text(
          title, 
          style: GoogleFonts.urbanist(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)
        ),
        subtitle: subtitle != null ? Text(
          subtitle, 
          style: GoogleFonts.urbanist(fontSize: 12, color: Colors.grey)
        ) : null,
        trailing: hideArrow ? null : const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
      ),
    );
  }

  // Widget TextField dengan Fitur Password
  Widget _buildTextField({
    required TextEditingController controller, 
    required String hint,
    bool obscureText = false,
    VoidCallback? onSuffixTap,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.urbanist(color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: onSuffixTap != null 
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: onSuffixTap,
                )
              : null,
        ),
      ),
    );
  }
}
