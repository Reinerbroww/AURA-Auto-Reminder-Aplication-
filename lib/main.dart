import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/splash_screen.dart';
import 'screens/masuk.dart';
import 'screens/daftar.dart';
import 'screens/home.dart';
import 'screens/tambah.dart';
import 'screens/seting.dart';
import 'services/notif_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔹 Kunci orientasi potrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // 🔹 Inisialisasi notifikasi
  await NotifService.init();

  // 🔹 Minta izin penting
  await _requestPermissions();

  // 🔹 Baca preferensi tema
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('dark_mode') ?? true;

  // 🔹 Tangani error global
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('❌ Flutter Error: ${details.exceptionAsString()}');
  };

  runApp(MyApp(isDarkMode: isDarkMode));
}

/// 🔐 Fungsi minta izin semua yang dibutuhkan
Future<void> _requestPermissions() async {
  // 1️⃣ Notifikasi (Android 13+)
  final notifStatus = await Permission.notification.status;
  if (notifStatus.isDenied || notifStatus.isRestricted) {
    await Permission.notification.request();
  }

  // 2️⃣ Exact alarm (Android 12+)
  final alarmStatus = await Permission.scheduleExactAlarm.status;
  if (alarmStatus.isDenied || alarmStatus.isRestricted) {
    await Permission.scheduleExactAlarm.request();
  }

  // 3️⃣ Battery optimization
  final ignoreBattery = await Permission.ignoreBatteryOptimizations.status;
  if (ignoreBattery.isDenied) {
    await Permission.ignoreBatteryOptimizations.request();
  }

  debugPrint("✅ Semua izin diperiksa & siap digunakan");
}

class MyApp extends StatelessWidget {
  final bool isDarkMode;
  const MyApp({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = isDarkMode
        ? ThemeData.dark().copyWith(
            scaffoldBackgroundColor: const Color(0xFF000814),
            primaryColor: Colors.blue,
            textTheme: ThemeData.dark().textTheme.apply(
                  fontFamily: 'Montserrat',
                ),
          )
        : ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            textTheme: ThemeData.light().textTheme.apply(
                  fontFamily: 'Montserrat',
                ),
          );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AURA',
      theme: theme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/masuk': (context) => const MasukPage(),
        '/daftar': (context) => const DaftarPage(),
        '/home': (context) => const HomePage(),
        '/tambah': (context) => const TambahPage(),
        '/setting': (context) => const SettingPage(),
      },
    );
  }
}
