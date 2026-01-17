import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';
import '../const.dart';

class NewsService {
  Future<List<NewsModel>> getLatestNews({
    String? category,
    String? language = 'en',
  }) async {
    try {
      // Build URL dengan parameter
      String url = '$beritaUrl?apiKey=$beritaApiToken';

      if (language != null && language.isNotEmpty) {
        url += '&language=$language';
      }

      if (category != null && category.isNotEmpty) {
        url += '&category=$category';
      }

      print('Fetching news from: $url');

      final response = await http.get(Uri.parse(url));

      print('Response status: ${response.statusCode}');
      print(
        'Response body: ${response.body.substring(0, response.body.length > 500 ? 500 : response.body.length)}',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Cek status dari API
        if (data['status'] == 'ok' &&
            data['news'] != null &&
            data['news'] is List) {
          List<NewsModel> newsList = (data['news'] as List)
              .map((article) => NewsModel.fromJson(article))
              .toList();
          print('Successfully loaded ${newsList.length} news articles');
          return newsList;
        } else {
          print('API returned non-ok status or no news: ${data['status']}');
          return [];
        }
      } else {
        print('Failed to load news: ${response.statusCode}');
        print('Error body: ${response.body}');
        return [];
      }
    } catch (e, stackTrace) {
      print('Error fetching news: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  Future<List<NewsModel>> searchNews(String query) async {
    try {
      final url = '$beritaUrl?apiKey=$beritaApiToken&keywords=$query';

      print('Searching news: $url');
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'ok' &&
            data['news'] != null &&
            data['news'] is List) {
          List<NewsModel> newsList = (data['news'] as List)
              .map((article) => NewsModel.fromJson(article))
              .toList();
          return newsList;
        }
        return [];
      } else {
        print('Failed to search news: ${response.statusCode}');
        print('Error body: ${response.body}');
        return [];
      }
    } catch (e, stackTrace) {
      print('Error searching news: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }
}
