# 📱 RestoRadar

RestoRadar adalah aplikasi penjelajah restoran berbasis mobile yang dirancang untuk membantu pengguna menemukan tempat makan terbaik, mengelola daftar restoran favorit, serta mengatur pengingat harian untuk rekomendasi kuliner. 

Aplikasi ini dibangun menggunakan **Flutter** dan **Dart** dengan menerapkan standar kode yang bersih melalui pola arsitektur **MVVM (Model-View-ViewModel)** serta memanfaatkan **Provider** sebagai solusi *state management*.

---

## 🛠️ Teknologi & Arsitektur Utama

* **Framework & Bahasa:** Flutter & Dart
* **State Management:** Provider
* **Pola Arsitektur:** MVVM (Model-View-ViewModel) untuk pemisahan yang jelas antara lapisan antarmuka (View) dan logika bisnis (ViewModel/Provider).
* **Penyimpanan Lokal:** * **SQLite** (via `sqflite`) untuk menyimpan data Restoran Favorit secara permanen pada perangkat.
  * **SharedPreferences** untuk menyimpan preferensi pengguna seperti tema aplikasi dan status pengingat.
* **Networking:** Integrasi REST API untuk penarikan data restoran secara *real-time*.
* **Background Task:** Penjadwalan otomatis di latar belakang untuk fitur notifikasi pengingat harian.

---

## 📂 Struktur Direktori Proyek

Eksplorasi kode sumber utama dilakukan di dalam direktori `lib/` yang terbagi secara modular:

```text
lib/
│
├── data/                  # Lapisan Data & Pengolahan Logika Bisnis
│   ├── api/               # Layanan HTTP request dan integrasi REST API
│   ├── local/             # Manajemen database lokal SQLite
│   ├── model/             # Class data (POJO) dan fungsi parsing JSON
│   └── provider/          # Lapisan ViewModel (State Management Provider)
│
├── screen/                # Lapisan View (Antarmuka Pengguna / UI)
│   ├── detail/            # Halaman detail informasi & ulasan restoran
│   ├── favorite/          # Halaman daftar restoran yang disukai pengguna
│   ├── home/              # Halaman beranda, daftar restoran, & fitur pencarian
│   ├── main/              # Kerangka utama aplikasi (Bottom Navigation)
│   └── settings/          # Halaman pengaturan preferensi aplikasi
│
├── utils/                 # Kelas Bantuan (Helpers & Config)
│   ├── background_task.dart    # Logika eksekusi tugas di latar belakang
│   ├── shared_preferences.dart # Helper enkapsulasi penyimpanan key-value
│   └── theme.dart              # Konfigurasi gaya visual, warna, dan tipografi
│
├── widget/                # Komponen UI modular yang dapat digunakan kembali (Reusable)
│
└── main.dart              # Titik masuk utama (Entry Point) aplikasi
