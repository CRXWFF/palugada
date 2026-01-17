class NewsModel {
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final String author;
  final DateTime publishedAt;
  final String category;

  NewsModel({
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.author,
    required this.publishedAt,
    required this.category,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      url: json['url'] ?? '',
      imageUrl: json['image'] ?? '',
      author: json['author'] ?? 'Unknown',
      publishedAt: DateTime.parse(
        json['published'] ?? DateTime.now().toIso8601String(),
      ),
      category:
          (json['category'] is List && (json['category'] as List).isNotEmpty)
          ? json['category'][0]
          : 'General',
    );
  }
}
