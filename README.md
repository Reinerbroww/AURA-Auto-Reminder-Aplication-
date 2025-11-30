AURA Auto Reminder Application

🌙 Apa itu AURA?

AURA (Auto Reminder Application) adalah aplikasi pengingat otomatis berbasis Flutter yang dirancang untuk membantu pengguna mengatur jadwal, tugas, dan aktivitas harian dengan cepat dan efisien.

Aplikasi ini dibuat agar pengguna tetap produktif dan tidak melewatkan momen penting, dengan sistem notifikasi yang stabil, tampilan modern, dan navigasi yang mudah.

AURA sangat cocok digunakan untuk mahasiswa, pekerja, atau siapa pun yang membutuhkan pengingat otomatis yang rapi dan terpercaya.


✨ Fitur Utama AURA

🔔 Notifikasi terjadwal (menggunakan flutter_local_notifications)

🎨 Tampilan UI bersih, modern, dan responsif

🌓 Dukungan Dark Mode & Light Mode

🧠 Manajemen jadwal: Tambah, hapus, edit pengingat

💾 Penyimpanan lokal dengan SQLite (sqflite)

🔐 Permission otomatis untuk notifikasi & alarm

📱 Optimal untuk Android 12 – 14 (SDK 36 ready)




🛠 Cara Clone & Menjalankan Project AURA (Step-by-step dari Nol)


1️⃣ Download & Install Flutter

Download Flutter SDK versi terbaru:

👉 https://docs.flutter.dev/get-started/install

Setelah download, extract Flutter ke lokasi yang kamu mau.
Tambahkan ke PATH (Windows):

C:\src\flutter\bin


Cek apakah sudah terinstall:

flutter --version


2️⃣ Install Android Studio

Download Android Studio:
👉 https://developer.android.com/studio

Setelah terinstall:

Buka SDK Manager

Install:

Android SDK 36

Android SDK Build-Tools

Android Platform-Tools

Android Emulator (opsional)


3️⃣ Clone Repository AURA

Jalankan perintah berikut:

git clone https://github.com/Reinerbroww/AURA-Auto-Reminder-Aplication-.git


Masuk ke folder project:

cd AURA-Auto-Reminder-Aplication-


4️⃣ Install Dependencies Flutter

Jalankan:

flutter pub get


5️⃣ Update & Sinkronisasi Android SDK

Karena AURA memakai plugin notifikasi baru, pastikan SDK 36 sudah ada:

sdkmanager "platforms;android-36"


6️⃣ Jalankan Aplikasi

Untuk mode debug:

flutter run


Untuk mode release:

flutter run --release

📌 Catatan Penting

Jika ada error Gradle, jalankan:

flutter clean
flutter pub get


Jika notifikasi tidak muncul, pastikan:

Izin notifikasi aktif

Battery optimization dimatikan untuk aplikasi


👤 Dibuat oleh:

MAIN DEVELOPER:
Reinnher Sakunab

SUPPORT DEVELOPER:
Hadynata Yusuf Pratama

Universitas Tadulako — Teknik Informatika
AURA Auto Reminder App • 2025