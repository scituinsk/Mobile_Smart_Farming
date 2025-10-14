# Pak Tani - Aplikasi Smart Farming

Aplikasi mobile "Pak Tani" yang dibangun menggunakan Flutter untuk membantu penyiraman dengan metode drip melalui perangkat IoT.

## ✨ Fitur Utama

-   **Autentikasi Pengguna:** Proses login untuk mengamankan akses ke data.
-   **Dashboard Utama:** Tampilan ringkas untuk semua modul sensor yang terpasang.
-   **Manajemen Modul:** Menambah dan melihat detail modul.
-   **Jadwal & Kontrol:** Mengatur jadwal penyiraman atau mengontrol penyiraman secara otomatis.
-   **Riwayat Data:** Melihat riwayat data green house dan peyiraman.
-   **Notifikasi:** Menerima pemberitahuan penting terkait kondisi lahan.
-   **Manajemen Profil:** Mengelola informasi akun pengguna.

## 🏗️ Arsitektur

Proyek ini dibangun dengan mengadopsi prinsip **Clean Architecture** yang dipadukan dengan framework **GetX** untuk menghasilkan aplikasi yang *scalable*, *maintainable*, dan *testable*.

Struktur proyek diorganisir berdasarkan fitur (*feature-driven*).

```
lib
├── src
│   ├── core/           # Kode shared (services, themes, navigation, widgets)
│   └── features/       # Folder untuk setiap fitur aplikasi
│       └── auth/
│           ├── application/  # Service spesifik fitur
│           ├── data/         # Implementasi repository & data source
│           ├── domain/       # Entitas, use case, & interface repository
│           └── presentation/ # UI (halaman), controller (Getx), & bindings
│       └── home/
│       └── ...
└── main.dart
```

### Lapisan Arsitektur

1.  **Domain:** Lapisan terdalam dan paling independen. Berisi logika bisnis inti (*use cases*) dan definisi kontrak data (*entities* & *repository interfaces*). Lapisan ini tidak memiliki dependensi ke Flutter atau package lainnya (pure Dart).

2.  **Data:** Bertanggung jawab menyediakan data untuk aplikasi. Lapisan ini berisi implementasi dari *repository interface* yang ada di `domain`, serta *data sources* yang berkomunikasi dengan API (remote) atau database lokal (local).

3.  **Presentation:** Lapisan terluar yang dilihat oleh pengguna. Berisi semua komponen UI (halaman/widget), serta state management menggunakan `GetxController`. Controller di lapisan ini berinteraksi dengan lapisan `domain` melalui *use cases*.

### State Management & Dependency Injection

-   **State Management:** Menggunakan `GetxController` dengan variabel reaktif (`.obs`) untuk mengelola state di setiap halaman.
-   **Dependency Injection:** Menggunakan `Bindings` dari GetX untuk mendaftarkan dan meng-inject dependensi (Repositories, Use Cases, Controllers) secara *lazy*.
-   **Routing:** Menggunakan `GetPage` dan `Get.toNamed()` untuk navigasi antar halaman.

## 🚀 Teknologi & Dependensi Utama

-   **Framework:** Flutter
-   **State Management:** GetX
-   **HTTP Client:** Dio
-   **Local Storage:** shared_preferences, flutter_secure_storage
-   **UI:** flutter_svg, google_fonts, lucide_icons, dan lainnya.

## 🏁 Memulai Proyek

### Prasyarat

-   Pastikan Anda sudah menginstal [Flutter SDK](https://flutter.dev/docs/get-started/install) (versi 3.x atau lebih tinggi).
-   Sebuah editor kode seperti VS Code atau Android Studio.

### Instalasi & Menjalankan

1.  **Clone repository ini:**
    ```sh
    git clone <URL_REPOSITORY_ANDA>
    cd pak_tani
    ```

2.  **Install dependensi:**
    ```sh
    flutter pub get
    ```

3.  **Jalankan aplikasi:**
    ```sh
    flutter run
    ```

