# AURA – Auto Reminder Application 🕒

**AURA (Auto Reminder Application)** adalah aplikasi pengingat otomatis berbasis **Flutter** yang membantu pengguna mengatur jadwal, tugas, dan aktivitas harian.
Tujuan AURA: bikin pengguna **lebih teratur**, **gak lupa jadwal**, dan tetap **produktif** dengan notifikasi yang terjadwal rapi.

---

## ✨ Fitur Utama

* 🔔 Notifikasi pengingat terjadwal (menggunakan `flutter_local_notifications`)
* 🌓 Tema **Dark Mode** & **Light Mode**
* 📝 Tambah, edit, dan hapus pengingat
* 💾 Penyimpanan lokal menggunakan **SQLite (sqflite)**
* 📅 Mendukung Android terbaru (compileSdk 36)
* 🔐 Izin notifikasi & alarm otomatis diminta saat aplikasi berjalan pertama kali

---

## 🧰 Teknologi yang Digunakan

* **Flutter** (Dart)
* **Android SDK**
* **SQLite** (`sqflite`)
* **Shared Preferences**
* `flutter_local_notifications`
* `permission_handler`

---

# 🛠 Cara Clone & Menjalankan AURA dari Nol (Langkah Demi Langkah)

---

## 1️⃣ Install Git

Git dipakai untuk meng-clone (mengambil) source code dari GitHub.

1. Download Git:
   [https://git-scm.com/downloads](https://git-scm.com/downloads)
2. Install Git seperti aplikasi biasa (Next → Next → Finish).
3. Setelah selesai, cek apakah Git sudah terpasang:

```bash
git --version
```

Kalau muncul versi (misal `git version 2.xx`), berarti Git sudah terinstall.

---

## 2️⃣ Install Flutter SDK

1. Buka panduan resmi Flutter:
   [https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install)
2. Download Flutter untuk **Windows** (atau OS kamu).
3. Extract ke folder, misalnya:

```text
C:\src\flutter
```

4. Tambahkan ke **PATH** (Windows):

   * Cari di Start Menu → “Edit the system environment variables”
   * Klik **Environment Variables**
   * Di “User variables” → pilih `Path` → **Edit**
   * Tambahkan entry baru:

```text
C:\src\flutter\bin
```

5. Cek Flutter di terminal / PowerShell:

```bash
flutter --version
```

Kalau muncul info versi Flutter, berarti sudah siap.

---

## 3️⃣ Install Android Studio & Android SDK

1. Download Android Studio:
   [https://developer.android.com/studio](https://developer.android.com/studio)
2. Install seperti biasa.
3. Buka Android Studio → klik **More Actions** → **SDK Manager**.
4. Pastikan ini tercentang:

   * Android **API 36** (Android 14)
   * Android SDK Platform-Tools
   * Android SDK Build-Tools
5. Masih di Android Studio, jalankan **SDK Manager** dari terminal (opsional):

```bash
sdkmanager "platforms;android-36"
```

---

## 4️⃣ Cek Kesiapan Flutter

Di terminal / PowerShell:

```bash
flutter doctor
```

Perintah ini akan memberi tahu kalau ada yang kurang (misalnya SDK belum lengkap).
Ikuti saran yang muncul sampai hampir semua tanda ✔ (kecuali bagian yang memang tidak dipakai, seperti web/macos jika tidak perlu).

---

## 5️⃣ Clone Repository AURA

Sekarang kita ambil source code AURA dari GitHub.

1. Pilih folder di laptop kamu, misalnya `C:\Users\ASUS\Downloads\AURA`
2. Buka terminal di folder tersebut, lalu jalankan:

```bash
git clone https://github.com/Reinerbroww/AURA-Auto-Reminder-Aplication-.git
```

3. Masuk ke folder project:

```bash
cd AURA-Auto-Reminder-Aplication-
```

---

## 6️⃣ Install Dependency Flutter

Masih di folder project (yang ada file `pubspec.yaml`), jalankan:

```bash
flutter pub get
```

Perintah ini akan mengunduh semua package yang dibutuhkan AURA (notifikasi, database, dll).

---

## 7️⃣ Hubungkan HP Android ke Laptop

Ada dua opsi: **pakai HP asli** atau **emulator**.

### ✅ Kalau pakai HP asli:

1. Aktifkan **Developer Options**:

   * Buka **Settings → About phone → Software information**
   * Tekan **Build number** 7x sampai muncul “You are now a developer”
2. Aktifkan **USB Debugging**:

   * Settings → Developer Options → hidupkan **USB debugging**
3. Sambungkan HP ke laptop pakai kabel data.
4. Cek apakah HP terbaca Flutter:

```bash
flutter devices
```

Kalau ada nama device kamu di daftar, berarti HP siap dipakai.

### ✅ Kalau pakai emulator (opsional):

1. Buka Android Studio → **Device Manager**
2. Tambah Virtual Device (AVD)
3. Jalankan emulator
4. Cek device:

```bash
flutter devices
```

---

## 8️⃣ Jalankan AURA di HP / Emulator

Masih di folder project AURA, jalankan:

```bash
flutter run
```

Kalau mau langsung mode **release** (lebih ringan & cepat):

```bash
flutter run --release
```

Flutter akan:

* Build project,
* Install APK ke HP/emulator,
* Menjalankan aplikasi secara otomatis.

---

## 9️⃣ Perintah Tambahan Kalau Ada Error

Kalau build error (misalnya setelah ganti kode atau update package), coba:

```bash
flutter clean
flutter pub get
flutter run
```

Kalau error terkait Gradle/SDK, pastikan:

* `compileSdk` di `android/app/build.gradle.kts` sudah **36**
* Android Studio sudah terinstall **API 36**

---

## 👨‍💻 Kontributor

**Developer Utama:**

* Reiner Dominicus Sakunab (Reinerbroww)

**Support & Kontributor:**

* Hadinata Yusuf Pratama
* Melin Oktaviani
