import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notif_service.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool notifikasi = true;
  bool darkMode = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notifikasi = prefs.getBool('notif_enabled') ?? true;
      darkMode = prefs.getBool('dark_mode') ?? true;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // hapus semua data user (email, user_id, tema, dll)

    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/masuk', (route) => false);
  }

  Future<void> _toggleNotifikasi(bool value) async {
    setState(() => notifikasi = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_enabled', value);

    if (!value) {
      // matikan semua notifikasi jika user nonaktifkan
      await NotifService.cancelAll();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Semua notifikasi dimatikan')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notifikasi diaktifkan')),
        );
      }
    }
  }

  Future<void> _toggleDarkMode(bool value) async {
    setState(() => darkMode = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tema akan diterapkan saat aplikasi dibuka kembali'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF000000), Color(0xFF0A2342)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  'Pengaturan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cinzel',
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // 🔔 Notifikasi
              SwitchListTile(
                title: const Text(
                  'Aktifkan Notifikasi',
                  style: TextStyle(color: Colors.white70),
                ),
                value: notifikasi,
                activeThumbColor: Colors.blueAccent,
                onChanged: _toggleNotifikasi,
              ),

              // 🌙 Mode gelap
              SwitchListTile(
                title: const Text(
                  'Mode Gelap',
                  style: TextStyle(color: Colors.white70),
                ),
                value: darkMode,
                activeThumbColor: Colors.blueAccent,
                onChanged: _toggleDarkMode,
              ),

              const Spacer(),

              // 🔹 Tombol Logout
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _logout,
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
