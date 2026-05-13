import 'package:flutter/material.dart';
import 'dart:html' as html;
import '../models/article.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  final String region;

  const ArticleCard({
    super.key,
    required this.article,
    required this.region,
  });

  Color get _biasColor {
    double score = _getScore();
    if (score <= -0.6) return const Color(0xFF1565C0);
    if (score <= -0.2) return const Color(0xFF42A5F5);
    if (score <= 0.2) return const Color(0xFF66BB6A);
    if (score <= 0.6) return const Color(0xFFEF5350);
    return const Color(0xFFB71C1C);
  }

  String get _biasLabel {
    double score = _getScore();
    if (score <= -0.6) return 'Far Left';
    if (score <= -0.2) return 'Moderate Left';
    if (score <= 0.2) return 'Center';
    if (score <= 0.6) return 'Moderate Right';
    return 'Far Right';
  }

  double _getScore() {
    if (article.regionalScores == null) return 0.0;
    switch (region) {
      case 'Australia':
        return article.regionalScores!.ausBias;
      case 'China':
        return article.regionalScores!.chinaBias;
      case 'Pacific':
        return article.regionalScores!.pacificBias;
      default:
        return article.regionalScores!.usBias;
    }
  }

  void _openArticle() {
    html.window.open(article.url, '_blank');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openArticle,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF161B22),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _biasColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    article.sourceName,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _biasColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _biasColor),
                    ),
                    child: Text(
                      _biasLabel,
                      style: TextStyle(
                        color: _biasColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                article.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                article.description,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              if (article.regionalScores != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _scoreChip('US', article.regionalScores!.usBias),
                    _scoreChip('AUS', article.regionalScores!.ausBias),
                    _scoreChip('CN', article.regionalScores!.chinaBias),
                    _scoreChip('PAC', article.regionalScores!.pacificBias),
                  ],
                ),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    article.publishedAt.length >= 10
                        ? article.publishedAt.substring(0, 10)
                        : article.publishedAt,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                  const Row(
                    children: [
                      Text(
                        'Read article',
                        style: TextStyle(
                          color: Color(0xFF238636),
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFF238636),
                        size: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scoreChip(String label, double score) {
    Color color;
    if (score <= -0.2) color = const Color(0xFF42A5F5);
    else if (score >= 0.2) color = const Color(0xFFEF5350);
    else color = const Color(0xFF66BB6A);

    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 10),
        ),
        const SizedBox(height: 2),
        Text(
          score.toStringAsFixed(2),
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}