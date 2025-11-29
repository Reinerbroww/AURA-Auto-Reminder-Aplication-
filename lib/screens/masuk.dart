import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/db_helper.dart';
import 'daftar.dart';
import 'home.dart';

class MasukPage extends StatefulWidget {
  const MasukPage({super.key});

  @override
  State<MasukPage> createState() => _MasukPageState();
}

class _MasukPageState extends State<MasukPage> {
  final DatabaseHelper db = DatabaseHelper();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  bool isLoading = false;

  Future<void> _login() async {
    final email = emailC.text.trim();
    final pwd = passC.text.trim();

    if (email.isEmpty || pwd.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username & Password wajib diisi')),
      );
      return;
    }

    setState(() => isLoading = true);

    final user = await db.getUser(email, pwd);

    setState(() => isLoading = false);

    if (user != null) {
      // ✅ Simpan user info ke SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', user['id']);
      await prefs.setString('username', user['email']);

      // ✅ Arahkan ke halaman Home
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username atau password salah')),
      );
    }
  }

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    super.dispose();
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
        child: SafeArea(
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
                      fontFamily: 'Cinzel',
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
                  const SizedBox(height: 40),
                  isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: _login,
                          child: const Text(
                            'Masuk',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DaftarPage()),
                      );
                    },
                    child: const Text(
                      'Belum punya akun? Daftar disini',
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
                      fontFamily: 'Cinzel',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
