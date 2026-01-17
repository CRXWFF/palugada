# Palugada

Palugada adalah aplikasi serbaguna berbasis Flutter yang mengintegrasikan berbagai layanan informasi real-time dalam satu platform. Aplikasi ini dirancang dengan antarmuka minimalis hitam putih untuk memberikan pengalaman pengguna yang fokus dan professional.

## Deskripsi

Palugada menyediakan akses cepat ke empat kategori informasi penting:

- **Informasi Cuaca** - Data cuaca real-time dengan deteksi lokasi otomatis
- **Berita Terkini** - Agregasi berita dari berbagai kategori
- **Data Pasar Saham** - Informasi harga saham dan pergerakan pasar
- **Konversi Mata Uang** - Kalkulator nilai tukar multi-currency

## Fitur

### Cuaca

Aplikasi menggunakan OpenWeather API untuk menampilkan kondisi cuaca terkini. Fitur yang tersedia:

- Deteksi lokasi otomatis menggunakan GPS
- Pencarian lokasi manual berdasarkan nama kota
- Tampilan suhu, kelembaban, dan kecepatan angin
- Format data yang mudah dibaca dengan update real-time

### Berita

Integrasi dengan Currents API menyediakan akses ke berita internasional:

- Filter berita berdasarkan 6 kategori (Bisnis, Teknologi, Olahraga, Hiburan, Sains, dan Umum)
- Tampilan card dengan thumbnail gambar
- Link langsung ke artikel sumber
- Refresh manual untuk update konten

### Saham

Menggunakan StockData API untuk menampilkan informasi pasar saham:

- 5 saham populer sebagai default (AAPL, GOOGL, MSFT, TSLA, AMZN)
- Pencarian saham berdasarkan simbol ticker
- Data harga, perubahan harian, dan volume perdagangan
- Indikator visual untuk pergerakan harga (naik/turun)

### Kurs Mata Uang

Implementasi ExchangeRate-API untuk konversi mata uang:

- Mendukung lebih dari 160 mata uang global
- Konversi real-time dengan rate terkini
- Interface swap untuk pertukaran mata uang cepat
- Riwayat timestamp update data

## Desain Aplikasi

Aplikasi mengadopsi prinsip desain minimalis dengan palet warna monokrom:

- **Warna Utama**: Hitam (#000000) dan Putih (#FFFFFF)
- **Tipografi**: Sans-serif dengan hierarchy yang jelas
- **Layout**: Grid 2 kolom untuk navigasi menu
- **Komponen**: Material Design dengan customization minimal

Pendekatan ini bertujuan mengurangi distraksi visual dan meningkatkan fokus pengguna pada konten informasi.

## Teknologi

- **Framework**: Flutter 3.x
- **Bahasa**: Dart
- **Arsitektur**: Stateful Widget dengan Service Layer
- **State Management**: Built-in Flutter State Management
- **Networking**: HTTP package untuk REST API calls
- **Local Storage**: SharedPreferences dan SQLite

## Instalasi

### Prasyarat

- Flutter SDK (versi 3.0 atau lebih tinggi)
- Dart SDK
- IDE (VS Code / Android Studio)
- Emulator atau perangkat fisik untuk testing

### Langkah Instalasi

1. Clone repository ini
2. Install dependencies:

```bash
flutter pub get
```

3. Buat file `.env` di folder `assets/` dengan struktur berikut:

```env
CURRENTS_API_TOKEN=your_currents_api_key
OPENWEATHER_API_TOKEN=your_openweather_api_key
STOCKDATA_API_TOKEN=your_stockdata_api_key
EXCHANGERATE_API_TOKEN=your_exchangerate_api_key
```

4. Dapatkan API keys dari provider berikut:
   - Currents API: https://currentsapi.services/en
   - OpenWeather API: https://openweathermap.org/api
   - StockData API: https://www.stockdata.org/
   - ExchangeRate-API: https://www.exchangerate-api.com/

5. Jalankan aplikasi:

```bash
flutter run
```

## Struktur Project

```
palugada/
├── lib/
│   ├── main.dart                    # Entry point aplikasi
│   ├── const.dart                   # Konstanta dan konfigurasi API
│   ├── models/                      # Data models
│   │   ├── weather_model.dart
│   │   ├── news_model.dart
│   │   ├── stock_model.dart
│   │   └── currency_model.dart
│   ├── services/                    # Layer API service
│   │   ├── weather_service.dart
│   │   ├── news_service.dart
│   │   ├── stock_service.dart
│   │   └── currency_service.dart
│   ├── screens/                     # UI screens
│   │   ├── home_screen.dart
│   │   ├── news_screen.dart
│   │   ├── stock_screen.dart
│   │   └── currency_screen.dart
│   └── widgets/                     # Reusable components
│       ├── weather_widget.dart
│       └── menu_card.dart
├── assets/
│   └── .env                         # Environment variables
└── pubspec.yaml                     # Dependencies configuration
```

## Permissions

Aplikasi memerlukan permissions berikut (sudah dikonfigurasi di AndroidManifest.xml dan Info.plist):

**Android:**

- `INTERNET` - Untuk API calls
- `ACCESS_FINE_LOCATION` - Deteksi lokasi presisi tinggi
- `ACCESS_COARSE_LOCATION` - Deteksi lokasi approximate

**iOS:**

- `NSLocationWhenInUseUsageDescription` - Permission lokasi saat aplikasi aktif
- `NSLocationAlwaysUsageDescription` - Permission lokasi background (optional)

## Roadmap Pengembangan

- Implementasi forecast cuaca 5 hari
- Fitur bookmark untuk berita dan saham favorit
- Push notification untuk alert perubahan signifikan
- Dark mode theme switching
- Visualisasi grafik historis untuk saham
- Filter berita advanced dengan keyword search
- Multi-location weather tracking
- Offline caching untuk data yang sering diakses

## Lisensi

Project ini dibuat untuk keperluan pembelajaran dan pengembangan personal.

## Versi

**v0.0.01** - Initial Release (17 Januari 2026)

- Implementasi empat modul utama (Cuaca, Berita, Saham, Currency)
- Integrasi dengan external APIs
- UI/UX design dengan monochrome theme
- Basic error handling dan loading states
