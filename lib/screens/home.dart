import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/db_helper.dart';
import '../models/reminder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = '';
  int? userId;
  List<Reminder> reminders = [];
  bool isLoading = true;

  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadUserAndReminders();
  }

  Future<void> _loadUserAndReminders() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Pengguna';
      userId = prefs.getInt('user_id');
    });

    if (userId != null) {
      final data = await dbHelper.getRemindersByUser(userId!);
      data.sort((a, b) => a.time.compareTo(b.time)); // sort berdasar jam
      setState(() {
        reminders = data;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> _refreshReminders() async {
    if (userId != null) {
      final data = await dbHelper.getRemindersByUser(userId!);
      data.sort((a, b) => a.time.compareTo(b.time));
      setState(() => reminders = data);
    }
  }

  Future<void> _deleteReminder(Reminder r) async {
    await dbHelper.deleteReminder(r.id!, userId!);

    setState(() {
      reminders.removeWhere((x) => x.id == r.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reminder "${r.title}" telah dihapus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PROFILE HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundImage: AssetImage('assets/profile.png'),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, $username',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          const Text(
                            'Mahasiswa',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pushNamed(context, '/setting'),
                    icon: const Icon(Icons.settings, color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'Jadwal Anda',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Cinzel',
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.blueAccent),
                      )
                    : reminders.isEmpty
                        ? const Center(
                            child: Text(
                              'Belum ada jadwal, tambahkan sekarang!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _refreshReminders,
                            child: ListView.builder(
                              itemCount: reminders.length,
                              itemBuilder: (context, index) {
                                final item = reminders[index];
                                return _scheduleCard(item);
                              },
                            ),
                          ),
              ),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  ),
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/tambah');
                    _refreshReminders();
                  },
                  child: const Text(
                    'Tambah',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  // CARD REMINDER
  Widget _scheduleCard(Reminder r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B263B), Color(0xFF415A77)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // INFO REMINDER
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r.title,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Jam: ${r.time}",
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
                Text(
                  "Link: ${r.link}",
                  style: const TextStyle(
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),

          // DELETE BUTTON
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Hapus Reminder"),
                  content: Text('Yakin ingin menghapus "${r.title}"?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Batal"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _deleteReminder(r);
                      },
                      child: const Text("Hapus"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
