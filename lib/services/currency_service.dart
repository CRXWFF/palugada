import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/currency_model.dart';
import '../const.dart';

class CurrencyService {
  Future<CurrencyListModel?> getSupportedCurrencies() async {
    try {
      final url = Uri.parse('$exchangeRateUrl$exchangeRateApiToken/codes');

      print('Fetching currencies from: $url');
      final response = await http.get(url);

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['result'] == 'success') {
          return CurrencyListModel.fromExchangeRateJson(data);
        } else {
          print('API returned error: ${data['error-type']}');
          return null;
        }
      } else {
        print('Failed to load currencies: ${response.statusCode}');
        return null;
      }
    } catch (e, stackTrace) {
      print('Error fetching currencies: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  Future<CurrencyModel?> convertCurrency({
    required String from,
    required String to,
    required double amount,
  }) async {
    try {
      // ExchangeRate-API pair conversion endpoint
      final url = Uri.parse(
        '$exchangeRateUrl$exchangeRateApiToken/pair/$from/$to/$amount',
      );

      print('Converting currency: $url');
      final response = await http.get(url);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['result'] == 'success') {
          return CurrencyModel.fromExchangeRateJson(data, amount);
        } else {
          print('API returned error: ${data['error-type']}');
          return null;
        }
      } else {
        print('Failed to convert currency: ${response.statusCode}');
        return null;
      }
    } catch (e, stackTrace) {
      print('Error converting currency: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  Future<Map<String, double>?> getLatestRates({String base = 'USD'}) async {
    try {
      final url = Uri.parse(
        '$exchangeRateUrl$exchangeRateApiToken/latest/$base',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['result'] == 'success') {
          final rates = data['conversion_rates'] as Map<String, dynamic>;
          return rates.map(
            (key, value) => MapEntry(key, (value as num).toDouble()),
          );
        }
      }
      return null;
    } catch (e) {
      print('Error getting rates: $e');
      return null;
    }
  }

  // Popular currency pairs
  List<String> getPopularCurrencies() {
    return ['USD', 'EUR', 'GBP', 'JPY', 'IDR', 'SGD', 'AUD', 'CNY'];
  }
}
