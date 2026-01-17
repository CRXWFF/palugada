import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/stock_model.dart';
import '../const.dart';

class StockService {
  Future<List<StockModel>> getStockQuotes(List<String> symbols) async {
    try {
      final symbolsString = symbols.join(',');
      final url = Uri.parse(
        '$stockUrl?symbols=$symbolsString&api_token=$stockApiToken',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['data'] != null && data['data'] is List) {
          List<StockModel> stocks = (data['data'] as List)
              .map((stock) => StockModel.fromJson(stock))
              .toList();
          return stocks;
        }
        return [];
      } else {
        print('Failed to load stocks: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching stocks: $e');
      return [];
    }
  }

  Future<StockModel?> getSingleStock(String symbol) async {
    try {
      final url = Uri.parse(
        '$stockUrl?symbols=$symbol&api_token=$stockApiToken',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['data'] != null &&
            data['data'] is List &&
            (data['data'] as List).isNotEmpty) {
          return StockModel.fromJson(data['data'][0]);
        }
        return null;
      } else {
        print('Failed to load stock: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching stock: $e');
      return null;
    }
  }

  // Popular Indonesian and US stocks
  List<String> getDefaultStocks() {
    return ['AAPL', 'GOOGL', 'MSFT', 'TSLA', 'AMZN'];
  }
}
