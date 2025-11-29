import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/db_helper.dart';
import '../models/reminder.dart';
import '../services/api_service.dart';
import '../services/notif_service.dart';

class TambahPage extends StatefulWidget {
  const TambahPage({super.key});

  @override
  State<TambahPage> createState() => _TambahPageState();
}

class _TambahPageState extends State<TambahPage> {
  final DatabaseHelper db = DatabaseHelper();

  final TextEditingController judulController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final TextEditingController jamController = TextEditingController();

  TimeOfDay? selectedTime;
  bool bukaOtomatis = false;
  bool isSaving = false;

  // ------------------- TIME PICKER -------------------
  Future<void> _pickTime() async {
    final TimeOfDay? hasil = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.blueAccent,
              secondary: Colors.blueAccent,
            ),
          ),
          child: child!,
        );
      },
    );

    if (hasil != null) {
      setState(() {
        selectedTime = hasil;
        jamController.text = hasil.format(context);
      });
    }
  }

  // ------------------- SIMPAN REMINDER -------------------
  Future<void> _save() async {
    if (judulController.text.isEmpty ||
        linkController.text.isEmpty ||
        jamController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi!')),
      );
      return;
    }

    // Validasi link
    if (!ApiService.isYouTube(linkController.text) &&
        !ApiService.isZoom(linkController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Link harus YouTube atau Zoom!')),
      );
      return;
    }

    setState(() => isSaving = true);

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan: User tidak ditemukan')),
      );
      setState(() => isSaving = false);
      return;
    }

    // ------------------- FORMAT WAKTU 24 JAM -------------------
    final now = DateTime.now();
    final formatted = DateFormat("HH:mm").format(
      DateFormat.jm().parse(jamController.text),
    );

    DateTime scheduled = DateFormat("HH:mm").parse(formatted);
    scheduled = DateTime(
      now.year,
      now.month,
      now.day,
      scheduled.hour,
      scheduled.minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    final reminder = Reminder(
      title: judulController.text,
      link: linkController.text,
      time: formatted,
      bukaOtomatis: bukaOtomatis,
    );

    try {
      await db.insertReminder(reminder, userId);

      // ------------------- NOTIFIKASI 3 MENIT SEBELUM + TEPAT WAKTU -------------------
      await NotifService.scheduleWithPreAlert(
        idBase: reminder.hashCode,
        title: "Reminder: ${reminder.title}",
        body: "Jam ${reminder.time} • ${reminder.link}",
        scheduledDate: scheduled,
        onTimeAction: () async {
          if (reminder.bukaOtomatis) {
            await ApiService.bukaLink(reminder.link);
          }
        },
      );

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reminder "${reminder.title}" berhasil disimpan!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $e')),
      );
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  void dispose() {
    judulController.dispose();
    linkController.dispose();
    jamController.dispose();
    super.dispose();
  }

  // ------------------- UI -------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Tambah Reminder',
          style: TextStyle(fontFamily: 'Cinzel', fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _inputField("Judul", judulController),
            const SizedBox(height: 12),
            _inputField("Link (YouTube/Zoom)", linkController),
            const SizedBox(height: 12),

            // ------------------- TIME PICKER FIELD -------------------
            TextField(
              controller: jamController,
              readOnly: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Pilih Jam',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white38),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
              ),
              onTap: _pickTime,
            ),

            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Buka Otomatis', style: TextStyle(color: Colors.white70)),
                const SizedBox(width: 8),
                Switch(
                  value: bukaOtomatis,
                  activeThumbColor: Colors.blueAccent,
                  onChanged: (v) => setState(() => bukaOtomatis = v),
                ),
              ],
            ),

            const SizedBox(height: 24),
            isSaving
                ? const CircularProgressIndicator(color: Colors.blueAccent)
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _save,
                    child: const Text(
                      'Simpan',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  // Custom Input UI
  Widget _inputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white38),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
      ),
    );
  }
}
