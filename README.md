# Palugada - Aplikasi Serbaguna

Aplikasi multi-fungsi dengan desain minimalis hitam putih yang menyediakan informasi cuaca, berita terkini, dan data saham.

## Fitur Utama

### 🌤️ Cuaca

- Ramalan cuaca real-time berdasarkan lokasi otomatis
- Pilihan lokasi manual dengan pencarian kota
- Informasi detail: suhu, kelembaban, kecepatan angin
- Data dari OpenWeather API

### 📰 Berita

- Berita terkini dari berbagai kategori
- Filter berdasarkan kategori (Bisnis, Teknologi, Olahraga, dll)
- Tampilan card dengan gambar dan deskripsi
- Link langsung ke artikel lengkap
- Data dari Currents API

### 📈 Saham

- Informasi saham real-time
- Pencarian simbol saham
- Data harga, perubahan, volume
- Statistik harian (tertinggi, terendah)
- Data dari StockData API

## Desain

- **Tema**: Hitam Putih (Monokrom)
- **Gaya**: Minimalis dan Professional
- **Layout**: Grid 2 kolom untuk menu
- **Icon**: Simple dan jelas

## Setup

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Setup API Keys

Buat file `.env` di folder `assets/` dengan isi:

```
CURRENTS_API_TOKEN=your_currents_api_key
OPENWEATHER_API_TOKEN=your_openweather_api_key
STOCKDATA_API_TOKEN=your_stockdata_api_key
```

**Cara Mendapatkan API Keys:**

- **Currents API**: https://currentsapi.services/en
- **OpenWeather API**: https://openweathermap.org/api
- **StockData API**: https://www.stockdata.org/

### 3. Jalankan Aplikasi

```bash
flutter run
```

## Permissions

Aplikasi memerlukan izin berikut:

- **Lokasi**: Untuk mendapatkan cuaca berdasarkan lokasi Anda
- **Internet**: Untuk mengambil data dari API

## Struktur Project

```
lib/
├── main.dart                 # Entry point aplikasi
├── const.dart                # Konstanta dan API endpoints
├── models/                   # Data models
│   ├── weather_model.dart
│   ├── news_model.dart
│   └── stock_model.dart
├── services/                 # API services
│   ├── weather_service.dart
│   ├── news_service.dart
│   └── stock_service.dart
├── screens/                  # Layar aplikasi
│   ├── home_screen.dart
│   ├── news_screen.dart
│   └── stock_screen.dart
└── widgets/                  # Reusable widgets
    ├── weather_widget.dart
    └── menu_card.dart
```

## Dependencies

- `http`: HTTP requests
- `geolocator`: Lokasi GPS
- `permission_handler`: Manajemen izin
- `flutter_dotenv`: Environment variables
- `intl`: Formatting tanggal dan angka
- `url_launcher`: Membuka URL eksternal
- `get`: State management
- `sqflite`: Local database
- `shared_preferences`: Local storage

## Teknologi

- **Framework**: Flutter
- **Bahasa**: Dart
- **API**: REST API
- **State Management**: StatefulWidget

## Roadmap

- [ ] Halaman detail cuaca dengan forecast 5 hari
- [ ] Favorit berita dan saham
- [ ] Notifikasi untuk perubahan cuaca/saham
- [ ] Mode gelap
- [ ] Grafik saham
- [ ] Pencarian berita advanced
- [ ] Multiple lokasi untuk cuaca

## Lisensi

Aplikasi ini dibuat untuk keperluan pribadi.

## Versi

v0.0.01 - Initial Release
