import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import 'package:intl/intl.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  final WeatherService _weatherService = WeatherService();
  WeatherModel? _weather;
  bool _isLoading = true;
  String? _error;
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadWeatherByLocation();
  }

  Future<void> _loadWeatherByLocation() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final weather = await _weatherService.getWeatherByLocation();

    setState(() {
      _weather = weather;
      _isLoading = false;
      if (weather == null) {
        _error = 'Tidak dapat memuat cuaca. Periksa izin lokasi.';
      }
    });
  }

  Future<void> _loadWeatherByCity(String city) async {
    if (city.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final weather = await _weatherService.getWeatherByCity(city);

    setState(() {
      _weather = weather;
      _isLoading = false;
      if (weather == null) {
        _error = 'Kota tidak ditemukan';
      }
    });
  }

  void _showCityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Lokasi'),
        content: TextField(
          controller: _cityController,
          decoration: const InputDecoration(
            hintText: 'Masukkan nama kota',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            Navigator.pop(context);
            _loadWeatherByCity(value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _loadWeatherByCity(_cityController.text);
            },
            child: const Text('Cari'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey[100]!, Colors.grey[200]!],
          ),
        ),
        child: Skeletonizer(
          enabled: _isLoading,
          child: _error != null && !_isLoading
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _error!,
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _loadWeatherByLocation,
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text('Coba Lagi'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: _showCityDialog,
                          icon: const Icon(Icons.location_city, size: 18),
                          label: const Text('Pilih Kota'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.black87,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _weather?.cityName ?? 'Loading City',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.location_city, size: 20),
                              onPressed: _showCityDialog,
                              color: Colors.black87,
                              tooltip: 'Pilih lokasi manual',
                            ),
                            IconButton(
                              icon: const Icon(Icons.refresh, size: 20),
                              onPressed: _loadWeatherByLocation,
                              color: Colors.black87,
                              tooltip: 'Refresh',
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    '${_weather?.temperature.round() ?? 25}',
                                    style: const TextStyle(
                                      fontSize: 56,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black87,
                                      height: 1,
                                    ),
                                  ),
                                  const Text(
                                    '°C',
                                    style: TextStyle(
                                      fontSize: 56,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _weather?.description.toUpperCase() ??
                                    'LOADING WEATHER',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _buildWeatherDetail(
                                Icons.thermostat,
                                'Terasa',
                                '${_weather?.feelsLike.round() ?? 24}°C',
                              ),
                              const SizedBox(height: 8),
                              _buildWeatherDetail(
                                Icons.water_drop,
                                'Kelembaban',
                                '${_weather?.humidity ?? 65}%',
                              ),
                              const SizedBox(height: 8),
                              _buildWeatherDetail(
                                Icons.air,
                                'Angin',
                                '${_weather?.windSpeed.toStringAsFixed(1) ?? '3.5'} m/s',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      DateFormat(
                        'EEEE, d MMMM yyyy HH:mm',
                        'id_ID',
                      ).format(_weather?.dateTime ?? DateTime.now()),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(IconData icon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(width: 4),
        Icon(icon, size: 16, color: Colors.grey[700]),
      ],
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}
