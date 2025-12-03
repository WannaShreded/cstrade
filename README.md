# CS2 Skin Gallery 🎮

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=flat-square&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-00B4AB?style=flat-square&logo=dart)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

Aplikasi galeri skin Counter-Strike 2 yang dibangun dengan Flutter. Jelajahi koleksi skin senjata dengan desain UI gaming modern, animasi halus, dan fitur favorit yang persisten.

## 📋 Daftar Isi

- [Fitur Utama](#-fitur-utama)
- [Tangkapan Layar](#-tangkapan-layar)
- [Stack Teknologi](#-stack-teknologi)
- [Struktur Folder](#-struktur-folder)
- [Instalasi & Menjalankan](#-instalasi--menjalankan)
- [Persyaratan](#-persyaratan)
- [Keputusan UI/UX](#-keputusan-uiux)
- [Roadmap & Peningkatan](#-roadmap--peningkatan)
- [Kredit](#-kredit)

## ✨ Fitur Utama

- **🔍 Pencarian & Filter**
  - Cari skin berdasarkan nama, senjata, atau kategori
  - Filter berdasarkan tingkat kelangkaan dan kondisi eksterieur
  - Debounce pencarian untuk performa optimal

- **🎴 Skin Card dengan Animasi**
  - Kartu skin responsif dengan hover effect
  - Floating info bar saat diklik
  - Gradient rarity color coding
  - Loading placeholder yang elegan

- **💎 Visualisasi Float Value**
  - Progress bar untuk menampilkan kondisi wear
  - Pemetaan warna kondisi eksterieur
  - Tooltip informatif float value

- **⭐ Hero Animation**
  - Transisi mulus dari card ke detail screen
  - Animasi gambar shared hero
  - Custom page transitions

- **❤️ Sistem Favorit**
  - Penyimpanan favorit menggunakan `shared_preferences`
  - Tanda favorit real-time di setiap skin card
  - Halaman favorit dedicated

- **🕐 Recently Viewed**
  - Pelacakan otomatis item yang dilihat
  - Penyimpanan hingga 12 item terakhir
  - Akses cepat ke skin favorit sebelumnya

- **🎨 Dark Mode Gaming UI**
  - Tema berwarna neon cyan (#00E5FF) dengan aksen biru
  - Desain responsif untuk berbagai ukuran layar
  - Material Design 3 compliance

## 📸 Tangkapan Layar

### Home Screen

<img width="275" height="980" alt="image" src="https://github.com/user-attachments/assets/913abf5b-93c2-46b8-b7e7-e75be6938fce" />



### Galeri/Browse
<img width="275" height="980" alt="image" src="https://github.com/user-attachments/assets/3ea129a2-d79e-4efc-93ba-d69e7a34d3d3" />


### Detail Screen
<img width="275" height="980" alt="image" src="https://github.com/user-attachments/assets/71f7d284-0b8e-42cb-b84e-42c3d80e85b6" />


## 🛠 Stack Teknologi

| Komponen | Teknologi | Versi |
|----------|-----------|-------|
| Framework | Flutter | 3.0+ |
| Bahasa | Dart | 3.0+ |
| State Management | Provider | ^6.0.0 |
| Local Storage | shared_preferences | ^2.0.0 |
| UI Framework | Material Design 3 | Built-in |
| HTTP Client | http | ^1.1.0 |

## 📁 Struktur Folder

```
cstrade/
├── lib/
│   ├── main.dart                    # Entry point aplikasi
│   └── src/
│       ├── models/
│       │   └── skin.dart            # Model data Skin
│       │
│       ├── screens/
│       │   ├── home_screen.dart     # Layar utama
│       │   ├── gallery_screen.dart  # Galeri kategori
│       │   ├── detail_screen.dart   # Detail skin
│       │   ├── search_filter_screen.dart
│       │   └── favorites_screen.dart
│       │
│       ├── widgets/
│       │   ├── skin_card.dart       # Kartu skin individu
│       │   ├── featured_carousel.dart
│       │   ├── recently_viewed.dart
│       │   ├── skin_filter_bar.dart
│       │   ├── float_progress.dart
│       │   └── custom_painters.dart
│       │
│       ├── services/
│       │   └── skin_service.dart    # Muatan data lokal
│       │
│       ├── storage/
│       │   ├── favorites_storage.dart
│       │   └── recently_viewed_storage.dart
│       │
│       ├── providers/
│       │   └── skin_provider.dart   # Provider state
│       │
│       └── utils/
│           ├── theme.dart           # Konfigurasi tema
│           └── navigation.dart      # Helper navigasi
│
├── assets/
│   ├── data/
│   │   └── skin.json               # Data skin lokal
│   └── images/
│       ├── thumbs/                 # Thumbnail skin
│       ├── full/                   # Gambar full skin
│       └── categories/             # Ikon kategori
│
├── android/                        # Konfigurasi Android
├── ios/                            # Konfigurasi iOS
├── pubspec.yaml                    # Dependensi Flutter
└── README.md                       # Dokumentasi ini
```

## 🚀 Instalasi & Menjalankan

### Prasyarat Awal

Pastikan Anda telah menginstal:

```bash
# Periksa instalasi Flutter
flutter doctor
```

### Langkah Instalasi

1. **Clone Repository**
   ```bash
   git clone https://github.com/yourusername/cstrade.git
   cd cstrade
   ```

2. **Install Dependensi**
   ```bash
   flutter pub get
   ```

3. **Generate Kode (jika diperlukan)**
   ```bash
   flutter pub run build_runner build
   ```

4. **Jalankan Aplikasi**

   **Untuk Emulator:**
   ```bash
   flutter run
   ```

   **Untuk Device Fisik:**
   ```bash
   # Pastikan device terhubung via USB
   flutter devices
   flutter run -d <device-id>
   ```

   **Untuk Mode Release:**
   ```bash
   flutter run --release
   ```

5. **Build APK (Android)**
   ```bash
   flutter build apk --release
   ```

6. **Build AAB (Android App Bundle)**
   ```bash
   flutter build appbundle --release
   ```

## 📦 Persyaratan

### SDK & Tools
- **Flutter SDK**: 3.0.0 atau lebih tinggi
- **Dart SDK**: 3.0.0 atau lebih tinggi
- **Android SDK**: API level 21 (Android 5.0) atau lebih tinggi
- **iOS**: iOS 11.0 atau lebih tinggi

### Hardware
- **RAM Minimum**: 4GB
- **Storage**: 500MB untuk development
- **Device Support**: Android 5.0+, iOS 11.0+

### Dependensi Penting

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0
  shared_preferences: ^2.0.0
  intl: ^0.19.0
```

## 🎨 Keputusan UI/UX

### Pilihan Desain

#### 1. **Dark Mode Gaming**
- Latar belakang navy (#071122) menciptakan atmosfer gaming profesional
- Neon cyan (#00E5FF) sebagai accent memberikan visual yang striking dan modern
- Mengurangi kelelahan mata untuk sesi browsing yang lama

#### 2. **Rarity Color Mapping**
```
Consumer Grade    → Silver   (#BDBDBД)
Industrial Grade  → Baby Blue (#64B5F6)
Mil-Spec          → Blue     (#2979FF)
Restricted        → Purple   (#8E24AA)
Classified        → Pink     (#EC407A)
Covert            → Red      (#E53935)
```
- Konsisten dengan game Counter-Strike 2
- Membantu identifikasi visual cepat

#### 3. **Card-Based Layout**
- Responsive grid (2 kolom di mobile, 3-4 di tablet)
- Hover effects di desktop, tap feedback di mobile
- Floating info bar menampilkan detail saat interaksi

#### 4. **Hero Animation**
- Smooth transition dari card → detail screen
- Shared image animation menciptakan continuity
- Meningkatkan perceived performance

#### 5. **Filter & Search**
- Debounced search (300ms) untuk performa
- Dropdown filters untuk rarity dan exterior
- Reset button untuk quick clear

## 🗺 Roadmap & Peningkatan

### ✅ Selesai (v1.0)
- [x] Home screen dengan featured carousel
- [x] Gallery browse dengan kategori
- [x] Detail screen dengan hero animation
- [x] Search & filter functionality
- [x] Favorit dengan persistence
- [x] Recently viewed tracking
- [x] Dark theme gaming UI
- [x] Float value visualization

### 🔄 Sedang Dikerjakan (v1.1)
- [ ] Sorting options (price, rarity, float)
- [ ] Price comparison charts
- [ ] Wishlist dengan multiple lists
- [ ] Share skin feature (image + details)

### 📋 Roadmap Masa Depan (v2.0+)
- [ ] Backend API integration
- [ ] Real-time price updates
- [ ] User authentication & profiles
- [ ] Trading/Marketplace features
- [ ] Inventory management
- [ ] Community reviews & ratings
- [ ] Push notifications
- [ ] Dark/Light mode toggle
- [ ] Multi-language support (EN, ID, CN)
- [ ] Offline mode dengan caching
- [ ] Export to CSV/PDF
- [ ] Advanced analytics dashboard

### Fitur Wishlist
- Virtual try-on AR (jika layak secara teknis)
- Float comparison tool
- Wear prediction calculator
- Market price API integration
- Social features (follow users, see their collections)

## 📝 Lisensi

Proyek ini dilisensikan di bawah [MIT License](LICENSE). Anda bebas menggunakan, memodifikasi, dan mendistribusikan kode ini.

## 🙏 Kredit & Pengakuan

### Sumber Daya
- **Counter-Strike 2** - Valve Corporation
  - Referensi data skin dan warna rarity
  - UI/UX gaming inspiration

- **Flutter Community**
  - Package provider untuk state management
  - shared_preferences untuk local storage
  - Material Design 3 guidelines

### Kontributor
- **Pengembang Utama**: [Muhammad Hijri Thoriq Maruf]
- **UX Designer**: [Muhammad Hijri Thoriq Maruf]
- **Data Researcher**: [Muhammad Hijri Thoriq Maruf]

### Inspirasi & Referensi
- [Flutter Documentation](https://flutter.dev/docs)
- [Material Design 3](https://m3.material.io)
- [Provider Package Guide](https://pub.dev/packages/provider)
- CS2 Official Community Resources

## 📞 Kontak & Support

Untuk pertanyaan, saran, atau laporan bug:

- **Issues**: [https://github.com/WannaShreded](#)
- **Email**: mhijrithoriqmrf@gmail.com

---

**Made with ❤️ for CS2 enthusiasts** • Last Updated: December 3, 2025
