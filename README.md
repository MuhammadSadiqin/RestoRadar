```python
markdown_content = """# 📱 RestoRadar - Dokumentasi Proyek

Selamat datang di dokumentasi resmi **RestoRadar**. Dokumentasi ini disusun secara terstruktur untuk memberikan pemahaman menyeluruh mengenai arsitektur, fitur, tampilan (UI), dan logika (logic) aplikasi. Aplikasi ini dibangun menggunakan **Flutter** dengan mengimplementasikan pola arsitektur **MVVM (Model-View-ViewModel)** dan **Provider** sebagai *state management*.

---

## 🛠 1. Teknologi & Arsitektur Utama

* **Framework:** Flutter
* **Bahasa Pemrograman:** Dart
* **State Management:** Provider
* **Arsitektur:** MVVM (Model-View-ViewModel) memisahkan antara logika bisnis (Provider) dan antarmuka pengguna (Screen/Widget).
* **Penyimpanan Lokal:** * SQLite (melalui `local_database_service.dart`) untuk data Restoran Favorit.
    * SharedPreferences (melalui `shared_preferences.dart`) untuk preferensi Tema dan Pengingat (Reminder).
* **Networking:** Mengambil data dari REST API (`api_services.dart`).
* **Background Task:** Menggunakan *background worker* untuk fitur pengingat harian (Daily Reminder).

---

## 📂 2. Struktur Direktori Proyek

Struktur folder pada proyek ini dirancang agar modular dan mudah di-*scale*. Semua *source code* utama berada di dalam folder `lib/`.


```

```text
Fetched content: /mnt/data/RestoRadar_Dokumentasi.md

```text
lib/
│
├── data/                  # Lapisan Model & Pengolahan Data
│   ├── api/               # Logika pemanggilan HTTP API (api_services.dart)
│   ├── local/             # Operasi database lokal SQLite (local_database_service.dart)
│   ├── model/             # Data class & parsing JSON (restaurant.dart, detail_response.dart, dll)
│   └── provider/          # Lapisan ViewModel (State Management dengan Provider)
│
├── screen/                # Lapisan View (Antarmuka Pengguna / UI)
│   ├── detail/            # Halaman detail restoran
│   ├── favorite/          # Halaman daftar favorit
│   ├── home/              # Halaman utama dan daftar restoran
│   ├── main/              # Halaman kerangka utama (Bottom Navigation)
│   └── settings/          # Halaman pengaturan aplikasi
│
├── utils/                 # Kelas bantuan (Helpers)
│   ├── background_task.dart # Logika penjadwalan notifikasi/pengingat
│   ├── shared_preferences.dart # Penyimpanan key-value
│   └── theme.dart         # Konfigurasi warna, tipografi, dan tema aplikasi
│
├── widget/                # Komponen UI yang dapat digunakan kembali (Reusable UI)
│
└── main.dart              # Entry point aplikasi

```

---

## ✨ 3. Penjelasan Fitur, Tampilan, dan Logika Modul

### A. Modul Kerangka Utama & Navigasi (Main Screen)

* **Lokasi File:** `lib/screen/main/main_screen.dart`, `lib/data/provider/main/bottom_nav_provider.dart`
* **Tampilan (UI):** Menampilkan kerangka dasar aplikasi dengan *Bottom Navigation Bar* yang menghubungkan pengguna ke halaman Home, Favorit, dan Settings.
* **Logika (Logic):** `bottom_nav_provider.dart` menyimpan *state* indeks tab yang sedang aktif. Saat pengguna mengetuk ikon navigasi, Provider akan memperbarui *state* dan mengubah halaman tanpa memuat ulang seluruh aplikasi.

### B. Modul Beranda & Daftar Restoran (Home Screen)

* **Lokasi File:** `lib/screen/home/home_screen.dart`, `lib/screen/home/restaurant_list_view.dart`, `lib/data/provider/home/restaurant_list_provider.dart`
* **Tampilan (UI):** Menampilkan sapaan pengguna dan daftar restoran yang ditarik dari API dalam bentuk *Card* (di-handle oleh `restaurant_card.dart`). Dilengkapi dengan indikator pemuatan (`loading_widget.dart`) dan *state* error (`custom_error_widget.dart`).
* **Logika (Logic):** 1. Saat layar diinisialisasi, `restaurant_list_provider` memanggil `api_services` untuk mengambil daftar restoran.
2. Data diproses dan diubah ke dalam bentuk objek `RestaurantListResponse`.
3. `ResultState` digunakan untuk mengatur kondisi UI (Loading, HasData, NoData, Error).

### C. Modul Pencarian (Search Screen)

* **Lokasi File:** `lib/screen/home/search_screen.dart`, `lib/data/provider/restaurant_search_provider.dart`
* **Tampilan (UI):** Terdapat kolom input (*TextField*) di bagian atas. Hasil pencarian akan muncul secara dinamis di bawahnya saat pengguna mengetik.
* **Logika (Logic):** Setiap *input* teks (query) dikirim ke `restaurant_search_provider`. Provider ini meneruskan *query* ke API pencarian (`api_services.dart`). Hasilnya kemudian di-render. Terdapat penanganan khusus jika hasil pencarian kosong (NoData).

### D. Modul Detail & Ulasan (Detail Screen)

* **Lokasi File:** `lib/screen/detail/detail_screen.dart`, `lib/screen/detail/detail_content.dart`, `lib/data/provider/detail/restaurant_detail_provider.dart`
* **Tampilan (UI):** Menampilkan gambar besar restoran, nama, kota, rating, deskripsi, daftar menu (makanan & minuman), dan daftar ulasan pelanggan (`review_card.dart`). Terdapat tombol FAB (Floating Action Button) untuk menambah ke Favorit, dan formulir (`review_form.dart`) untuk menambah ulasan baru.
* **Logika (Logic):** 1. Membutuhkan ID restoran yang dikirim melalui parameter navigasi (`navigation_route.dart`).
2. `restaurant_detail_provider` mengambil detail lengkap dari API berdasarkan ID.
3. Pengguna dapat menambah ulasan yang dikirim langsung melalui API POST request, dan UI akan di-*refresh* setelah berhasil.

### E. Modul Favorit (Favorite Screen)

* **Lokasi File:** `lib/screen/favorite/favorites_screen.dart`, `lib/data/provider/favorite/local_database_provider.dart`, `lib/data/local/local_database_service.dart`
* **Tampilan (UI):** Menampilkan daftar restoran layaknya halaman Home, namun khusus untuk restoran yang sudah di-*bookmark* atau disukai oleh pengguna.
* **Logika (Logic):** 1. Berjalan sepenuhnya secara *offline* membaca data dari SQLite (`local_database_service`).
2. Saat pengguna menekan tombol "Hati" (Favorite) di halaman detail, `local_database_provider` akan menyimpan data restoran (Insert) atau menghapusnya (Delete) dari tabel lokal.
3. Halaman ini akan secara reaktif memperbarui daftar ketika ada restoran baru yang ditambahkan atau dihapus.

### F. Modul Pengaturan & Pengingat (Settings Screen)

* **Lokasi File:** `lib/screen/settings/setting_screen.dart`, `lib/data/provider/theme/theme_provider.dart`, `lib/data/provider/reminder/reminder_provider.dart`
* **Tampilan (UI):** Berisi opsi-opsi preferensi pengguna menggunakan *Switch/Toggle* atau *Card Option* (`theme_option_card.dart`).
* **Tema:** Pilihan untuk menggunakan *Light Mode* atau *Dark Mode*.
* **Notifikasi:** *Toggle* untuk mengaktifkan pengingat harian (Rekomendasi Restoran).


* **Logika (Logic):** * **Theme Provider:** Membaca/menyimpan pilihan tema menggunakan `shared_preferences.dart`. Perubahan akan memicu (*notifyListeners*) pembaruan tema secara global melalui parameter `theme` di `MaterialApp` (`main.dart`).
* **Reminder Provider:** Mengatur *Background Task* (`background_task.dart`) yang dipadukan dengan konfigurasi waktu lokal (`local_time_config.dart`) untuk menjadwalkan notifikasi harian pada jam tertentu.



---

## 🔄 4. Alur Manajemen State (MVVM Flow)

Aplikasi ini menggunakan pola komunikasi searah (Unidirectional Data Flow) yang difasilitasi oleh **Provider**:

1. **View (UI):** Pengguna berinteraksi dengan layar (misal: membuka halaman Detail). UI memanggil fungsi pada Provider (misal: `provider.fetchDetail(id)`).
2. **ViewModel (Provider):** Provider mengubah statusnya menjadi `ResultState.loading` dan memberitahu UI. Lalu memanggil fungsi dari Data Layer.
3. **Model/Data Layer:** `api_services` (atau `local_database_service`) melakukan tugasnya (misal HTTP GET) dan mengembalikan respons model data ke Provider.
4. **Update State:** Provider memproses data tersebut. Jika sukses, status berubah menjadi `ResultState.hasData`. Jika gagal, status menjadi `ResultState.error`. Provider kemudian memanggil `notifyListeners()`.
5. **Rebuild UI:** Widget yang "mendengarkan" (*Consumer* atau `context.watch`) akan membangun ulang tampilannya sesuai dengan *state* dan data terbaru.

---

## 🚀 5. Praktik Terbaik Code Quality

Sesuai dengan konfigurasi `analysis_options.yaml`, proyek ini menerapkan standar kode (*linting*) yang ketat. Penggunaan struktur yang bersih (pemisahan *widget*, logika *background task*, dan abstraksi *helper* seperti `image_helper.dart`) membuat *codebase* sangat *maintainable* dan siap untuk pengembangan lebih lanjut.

---

*Dokumentasi ini dirancang agar mudah dibaca oleh Developer maupun Stakeholder untuk memahami ruang lingkup proyek RestoRadar secara komprehensif.*
"""

file_path = "/mnt/data/RestoRadar_Dokumentasi.md"
with open(file_path, "w", encoding="utf-8") as f:
f.write(markdown_content)
print(f"Fetched content: {file_path}")

```
Your Markdown file is ready
[file-tag: code-generated-file-0-1779629052604966132]

Dokumentasi proyek **RestoRadar** telah berhasil dibuat dan disimpan dalam format Markdown. 

Dokumentasi ini disusun agar rapi, terstruktur, dan sangat nyaman dibaca. Isinya mencakup:
* **Struktur Arsitektur:** Penjelasan pemisahan logika bisnis dan antarmuka dengan pola MVVM dan Provider, sehingga mempermudah pemahaman alur data.
* **Bedah Modul (Logika & UI):** Penjelasan fungsionalitas dari setiap bagian, mulai dari halaman *Home* (pengambilan data API), *Search*, *Detail* & *Review*, hingga *Favorite* (penyimpanan lokal SQLite) dan *Settings* (pengaturan *Theme* & *Daily Reminder*).
* **Alur Manajemen Data:** Penjelasan langkah demi langkah bagaimana data mengalir secara searah dari API/Database Lokal ke UI melalui *state management*, memastikan kode tetap bersih dan mudah di-*maintain*.

Anda dapat mengunduh file `.md` di atas untuk langsung digunakan pada *repository* proyek (seperti GitHub/GitLab) atau sebagai acuan pengembangan selanjutnya.

```
