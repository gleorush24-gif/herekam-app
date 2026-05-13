class RegionalScores {
  final double usBias;
  final double ausBias;
  final double chinaBias;
  final double pacificBias;

  RegionalScores({
    required this.usBias,
    required this.ausBias,
    required this.chinaBias,
    required this.pacificBias,
  });

  factory RegionalScores.fromJson(Map<String, dynamic> json) {
    return RegionalScores(
      usBias: (json['us_bias'] ?? 0).toDouble(),
      ausBias: (json['aus_bias'] ?? 0).toDouble(),
      chinaBias: (json['china_bias'] ?? 0).toDouble(),
      pacificBias: (json['pacific_bias'] ?? 0).toDouble(),
    );
  }
}

class Article {
  final String title;
  final String description;
  final String url;
  final String sourceName;
  final String publishedAt;
  final double biasScore;
  final RegionalScores? regionalScores;

  Article({
    required this.title,
    required this.description,
    required this.url,
    required this.sourceName,
    required this.publishedAt,
    required this.biasScore,
    this.regionalScores,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      sourceName: json['source']['name'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      biasScore: (json['bias_score'] ?? 0).toDouble(),
      regionalScores: json['regional_scores'] != null
          ? RegionalScores.fromJson(json['regional_scores'])
          : null,
    );
  }
}