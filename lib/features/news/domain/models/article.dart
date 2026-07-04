class Article {
  final String title;
  final String description;
  final String urlToImage;
  final String content;

  Article({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.content,
  });

  // Mengubah data JSON dari API menjadi Objek Dart
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'Tanpa Judul',
      description: json['description'] ?? 'Tidak ada deskripsi.',
      urlToImage: json['urlToImage'] ?? '',
      content: json['content'] ?? 'Konten tidak tersedia.',
    );
  }
}