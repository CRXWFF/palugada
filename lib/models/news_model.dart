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
    try {
      return NewsModel(
        title: json['title']?.toString() ?? 'No Title',
        description: json['description']?.toString() ?? 'No Description',
        url: json['url']?.toString() ?? '',
        imageUrl: json['image']?.toString() ?? '',
        author: json['author']?.toString() ?? 'Unknown',
        publishedAt: json['published'] != null
            ? DateTime.parse(json['published'])
            : DateTime.now(),
        category:
            (json['category'] is List && (json['category'] as List).isNotEmpty)
            ? (json['category'][0]?.toString() ?? 'General')
            : (json['category']?.toString() ?? 'General'),
      );
    } catch (e) {
      print('Error parsing news article: $e');
      print('JSON data: $json');
      // Return default values if parsing fails
      return NewsModel(
        title: 'Error Loading Title',
        description: 'Error Loading Description',
        url: '',
        imageUrl: '',
        author: 'Unknown',
        publishedAt: DateTime.now(),
        category: 'General',
      );
    }
  }
}
