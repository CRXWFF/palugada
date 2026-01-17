import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';
import '../const.dart';

class NewsService {
  Future<List<NewsModel>> getLatestNews({
    String? category,
    String? language = 'id',
  }) async {
    try {
      String url = '$beritaUrl?apiKey=$beritaApiToken';

      if (category != null && category.isNotEmpty) {
        url += '&category=$category';
      }

      if (language != null && language.isNotEmpty) {
        url += '&language=$language';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['news'] != null && data['news'] is List) {
          List<NewsModel> newsList = (data['news'] as List)
              .map((article) => NewsModel.fromJson(article))
              .toList();
          return newsList;
        }
        return [];
      } else {
        print('Failed to load news: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching news: $e');
      return [];
    }
  }

  Future<List<NewsModel>> searchNews(String query) async {
    try {
      final url = '$beritaUrl?apiKey=$beritaApiToken&keywords=$query';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['news'] != null && data['news'] is List) {
          List<NewsModel> newsList = (data['news'] as List)
              .map((article) => NewsModel.fromJson(article))
              .toList();
          return newsList;
        }
        return [];
      } else {
        print('Failed to search news: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error searching news: $e');
      return [];
    }
  }
}
