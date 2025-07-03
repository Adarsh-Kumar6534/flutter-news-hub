// lib/models/article.dart
class Article {
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? author;
  final String? content;

  Article({
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.author,
    this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] as String?,
      description: json['description'] as String?,
      url: json['url'] as String?,
      urlToImage: json['urlToImage'] as String?,
      publishedAt: json['publishedAt'] as String?,
      author: json['author'] as String?,
      content: json['content'] as String?,
    );
  }
}
