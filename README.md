# 🌙 AURA — Auto Reminder Application  
Aplikasi pengingat otomatis berbasis Flutter yang dirancang untuk membantu pengguna mengelola jadwal harian, pengingat penting, hingga aktivitas produktivitas dengan cepat, mudah, dan efisien.

AURA dibangun dengan tujuan memberikan pengalaman pengguna yang nyaman, tampilan elegan, serta sistem notifikasi yang stabil dan dapat diandalkan.

---

## ✨ Fitur Utama

### 🔔 Smart Local Notification  
- Pengingat otomatis menggunakan `flutter_local_notifications`
- Mendukung notifikasi terjadwal (daily / sekali)
- Notifikasi tetap berjalan meski aplikasi ditutup

### 🎨 UI Modern & Clean  
- Menggunakan font **Cinzel** & **Montserrat**  
- Mode terang & gelap (Light/Dark Mode)

### 🧠 Manajemen Jadwal yang Mudah  
- Tambah, edit, dan hapus pengingat  
- Data tersimpan lokal menggunakan **SQLite (sqflite)**  
- Navigasi cepat dan responsif

### 📱 Optimal untuk Android  
- Kompatibel Android 12 – Android 14  
- Desugaring Java 8+ untuk performa maksimal

---

## 📁 Teknologi yang Digunakan

| Teknologi | Keterangan |
|----------|------------|
| Flutter 3.x | Framework utama |
| Dart | Bahasa pemrograman |
| flutter_local_notifications | Sistem notifikasi |
| sqflite | Database lokal |
| shared_preferences | Menyimpan preferensi UI |
| permission_handler | Meminta izin perangkat |
| timezone | Akurasi penjadwalan notifikasi |

---

## 🔧 Instalasi & Menjalankan Project

Ikuti langkah-langkah berikut untuk meng-clone dan menjalankan AURA secara lokal.

### 1️⃣ Clone Repository  
```bash
git clone https://github.com/Reinerbroww/AURA-Auto-Reminder-Aplication-.git


2️⃣ Masuk ke Folder Project
cd AURA-Auto-Reminder-Aplication-

3️⃣ Install Semua Dependency
flutter pub get

4️⃣ Pastikan Android SDK Sudah Terinstall

Minimal SDK: Android 36

Cek apakah sudah tersedia:

sdkmanager --list


Jika belum ada:

sdkmanager "platforms;android-36"

5️⃣ Jalankan Aplikasi
flutter run


Jika ingin menjalankan mode release:

flutter run --release

📂 Struktur Folder
AURA/
├── android/                # File konfigurasi Android
├── assets/
│   ├── fonts/              # Font Cinzel & Montserrat
│   └── logo_aura.png
├── lib/
│   ├── screens/            # Halaman aplikasi (Home, Daftar, Masuk, dll)
│   ├── services/           # Notifikasi, database, helper
│   ├── widgets/            # Custom widget
│   └── main.dart           # Entry point aplikasi
├── pubspec.yaml            # Dependency project
└── README.md

👨‍💻 Developer

Reiner Dominicus Sakunab (Reinerbroww)
AURA — Auto Reminder Application
Universitas Tadulako | Teknik Informatika

📜 Lisensi (Opsional)
MIT License  
Project bebas digunakan untuk pembelajaran & pengembangan.
