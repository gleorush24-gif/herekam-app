import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class ApiService {
  static String get baseUrl {
    return 'https://herekam-backend-1.onrender.com';
  }

  static Future<List<Article>> fetchNews(String topic) async {
    final url = Uri.parse('$baseUrl/news?topic=$topic');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List articles = data['articles'];
        return articles.map((a) => Article.fromJson(a)).toList();
      } else {
        throw Exception('Failed to fetch news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }
}