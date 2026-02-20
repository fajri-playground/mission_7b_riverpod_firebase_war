import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// Modal Tambah & Edit Kebiasaan
///
/// Widget ini berupa Bottom Sheet yang berfungsi ganda:
/// 1. Mode Tambah: Jika existingHabit null, form dimulai kosong.
/// 2. Mode Edit: Jika existingHabit ada, form terisi data lama.
///
/// Fitur Utama:
/// - Input Nama Habit
/// - Input Waktu (Time Picker) & Tanggal Mulai (Date Picker)
/// - Opsi Pengulangan (Daily, Weekly/Specific Days)
/// - Target Selesai (End Date) opsional
class AddHabitModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onHabitCreated;
  
  /// Data habit lama (Opsional). Jika diisi, modal akan masuk ke Mode Edit.
  final Map<String, dynamic>? existingHabit; 

  const AddHabitModal({
    super.key, 
    required this.onHabitCreated, 
    this.existingHabit
  });

  @override
  State<AddHabitModal> createState() => _AddHabitModalState();
}

class _AddHabitModalState extends State<AddHabitModal> {
  // Controllers
  final TextEditingController nameController = TextEditingController();
  TimeOfDay selectedTime = const TimeOfDay(hour: 9, minute: 0);
  DateTime selectedDate = DateTime.now();
  DateTime? endDate;

  // Repeat Options
  String selectedRepeat = 'Daily'; 
  List<String> repeatOptions = ['Daily', 'Weekly', 'Specific Days'];

  // Specific Days Toggles
  List<bool> selectedDays = [false, false, false, false, false, false, false];
  List<String> dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  void initState() {
    super.initState();
    // Jika ada Data Lama -> Isi Form (Mode Edit)
    if (widget.existingHabit != null) {
      final data = widget.existingHabit!;
      nameController.text = data['title'];
      
      // Parse Time (String "9:00 AM" -> TimeOfDay)
      try {
        if (data['time'] != null) {
           // Simple parsing logic, assuming format "h:mm a" or "HH:mm"
           // For simplicity, we can use DateFormat again or manual split
           // Let's try simple DateFormat
           final dt = DateFormat("h:mm a").parse(data['time']); // May throw if format differs
           selectedTime = TimeOfDay(hour: dt.hour, minute: dt.minute);
        }
      } catch (e) {
        // Fallback or ignore
      }

      if (data['startDate'] != null) selectedDate = DateTime.parse(data['startDate']);
      if (data['endDate'] != null) endDate = DateTime.parse(data['endDate']);
      if (data['repeat'] != null) selectedRepeat = data['repeat'];
      
      // Load Selected Days
      if (data['specificDays'] != null) {
        selectedDays = List<bool>.from(data['specificDays']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.existingHabit != null;

    // Gunakan Padding untuk mengangkat modal saat keyboard muncul
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        // Hapus fixed height agar 'wrap content' (responsif)
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        child: SingleChildScrollView(
          // SingleChildScrollView agar bisa discroll jika konten melebihi layar (misal landscape/hp kecil)
          child: Column(
            mainAxisSize: MainAxisSize.min, // CRITICAL: Agar tinggi modal mengikuti kontennya
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle Bar
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Center(
                child: Text(
                  isEditing ? "Edit Habit" : "Create New Habit",
                  style: GoogleFonts.urbanist(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 1. NAME
              _buildLabel("Habit Name"),
              _buildTextField(nameController, "e.g., Read Physics Book"),
              const SizedBox(height: 20),

              // 2. TIME & START DATE (ROW)
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Time"),
                        GestureDetector(
                          onTap: () async {
                            final t = await showTimePicker(
                              context: context,
                              initialTime: selectedTime,
                            );
                            if (t != null) setState(() => selectedTime = t);
                          },
                          child: _buildPickerContainer(
                            selectedTime.format(context),
                            Icons.access_time,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Start Date"),
                        GestureDetector(
                          onTap: () async {
                            final d = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2030),
                            );
                            if (d != null) setState(() => selectedDate = d);
                          },
                          child: _buildPickerContainer(
                            DateFormat('dd MMM yyyy').format(selectedDate),
                            Icons.calendar_today,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 3. REPEAT FREQUENCY
              _buildLabel("Repeat Frequency"),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedRepeat,
                    isExpanded: true,
                    items: repeatOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: GoogleFonts.urbanist()),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedRepeat = val!;
                        if (selectedRepeat == 'Daily') {
                          selectedDays = List.filled(7, true);
                        }
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 4. SPECIFIC DAYS SELECTOR
              if (selectedRepeat != 'Daily') ...[
                _buildLabel("On which days?"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (index) {
                    bool isSelected = selectedDays[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDays[index] = !selectedDays[index];
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF2FB969)
                              : Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            dayLabels[index],
                            style: GoogleFonts.urbanist(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
              ],

              // 5. END DATE (Optional)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabel("End Date (Goal)"),
                  Switch(
                    value: endDate != null,
                    activeColor: const Color(0xFF2FB969),
                    onChanged: (val) {
                      setState(() {
                        endDate = val
                            ? DateTime.now().add(const Duration(days: 30))
                            : null;
                      });
                    },
                  )
                ],
              ),
              if (endDate != null)
                GestureDetector(
                  onTap: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: endDate!,
                      firstDate: selectedDate,
                      lastDate: DateTime(2035),
                    );
                    if (d != null) setState(() => endDate = d);
                  },
                  child: _buildPickerContainer(
                    DateFormat('dd MMM yyyy').format(endDate!),
                    Icons.flag_rounded,
                  ),
                ),

              const SizedBox(height: 30),

              // SUBMIT BUTTON (Sekarang bagian dari scroll)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _submitHabit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2FB969),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    isEditing ? "Save Changes" : "Create Habit",
                    style: GoogleFonts.urbanist(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30), // Bottom Safe Arra
            ],
          ),
        ),
      ),
    );
  }

  /// Logika Submit (Simpan Data)
  /// 
  /// Langkah-langkah:
  /// 1. Validasi: Memastikan Nama tidak kosong (Wajib).
  /// 2. Generate Subtitle: Membuat ringkasan jadwal text (contoh: "Daily • 09:00 AM") untuk UI.
  /// 3. Konstruksi Data: Membungkus semua input ke dalam Map objek.
  /// 4. Callback: Mengirim data kembali ke parent (HomePage) via onHabitCreated.
  void _submitHabit() {
    // 1. Validasi Nama
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name cannot be empty!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 2. Generate Subtitle/Summary (Untuk display di List)
    String subtitle = "";
    if (selectedRepeat == 'Daily') {
      subtitle = "Daily • ${selectedTime.format(context)}";
    } else {
      int activeCount = selectedDays.where((e) => e).length;
      if (activeCount == 7) {
        subtitle = "Every day • ${selectedTime.format(context)}";
      } else if (activeCount == 0) {
        subtitle = "No days selected";
      } else {
        subtitle = "$activeCount times/week • ${selectedTime.format(context)}";
      }
    }

    // 3. Konstruksi Data Object
    final newHabit = {
      "title": nameController.text,
      "subtitle": subtitle,
      // Pertahankan status lama jika mode Edit (jangan di-reset ke pending)
      "status": widget.existingHabit != null ? widget.existingHabit!['status'] : "pending",
      "time": selectedTime.format(context),
      "repeat": selectedRepeat,
      "startDate": selectedDate.toIso8601String(),
      "endDate": endDate?.toIso8601String(), // Nullable
      "specificDays": selectedDays, // Array Boolean [Sen, Sel, Rab...] penting untuk filter tanggal
    };

    // 4. Kirim Data & Tutup Modal
    widget.onHabitCreated(newHabit); 
    Navigator.pop(context); 
  }

  // Helper Widgets
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.urbanist(color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildPickerContainer(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text,
              style: GoogleFonts.urbanist(fontSize: 15, color: Colors.black87)),
          Icon(icon, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}
