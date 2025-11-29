import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import 'masuk.dart';

class DaftarPage extends StatefulWidget {
  const DaftarPage({super.key});

  @override
  State<DaftarPage> createState() => _DaftarPageState();
}

class _DaftarPageState extends State<DaftarPage> {
  final DatabaseHelper db = DatabaseHelper();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  final TextEditingController confirmC = TextEditingController();

  Future<void> _daftar() async {
    final email = emailC.text.trim();
    final pwd = passC.text.trim();
    final conf = confirmC.text.trim();

    if (email.isEmpty || pwd.isEmpty || conf.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field wajib diisi')),
      );
      return;
    }
    if (pwd != conf) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password tidak sama')),
      );
      return;
    }

    try {
      await db.insertUser(email, pwd);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Akun dibuat, silakan login')),
      );
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MasukPage()),
        );
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username sudah terdaftar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black87, Colors.blueGrey],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Selamat Datang...',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: emailC,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Masukan Username...',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passC,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Masukan Password...',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: confirmC,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Konfirmasi Password...',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: _daftar,
                  child: const Text(
                    'Daftar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MasukPage()),
                  ),
                  child: const Text(
                    'Sudah punya akun? Masuk',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  'AUTO REMINDER\nAPPLICATION',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
