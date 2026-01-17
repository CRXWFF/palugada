import 'package:flutter_dotenv/flutter_dotenv.dart';

// Currents API (Berita)
final beritaApiToken = dotenv.env['CURRENTS_API_TOKEN'];
const String beritaUrl = 'https://api.currentsapi.services/v1/latest-news';

// OpenWeather API (Cuaca)
final weatherApiToken = dotenv.env['OPENWEATHER_API_TOKEN'];
const String weatherUrl = 'https://api.openweathermap.org/data/2.5/weather';
const String forecastUrl = 'https://api.openweathermap.org/data/2.5/forecast';

// StockData API (Saham)
final stockApiToken = dotenv.env['STOCKDATA_API_TOKEN'];
const String stockUrl = 'https://api.stockdata.org/v1/data/quote';
