import 'dart:convert';

import 'package:catch_news/models/articles.dart';
import 'package:catch_news/models/news.dart';
import 'package:http/http.dart' as http;

class NewsService {
  Future<List<Articles>> fetchNews(String category) async {
    String url = 
  'https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=da56d32fe4aa451b90c9ad7a31cc9f7d';
  Uri uri = Uri.parse(url);
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    final result = jsonDecode(response.body);
    News news = News.fromJson(result);
    return news.articles ?? [];
  }
  throw Exception('Bad request');
  }
}