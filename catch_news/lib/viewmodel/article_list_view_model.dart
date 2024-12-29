import 'package:flutter/cupertino.dart';
import 'package:catch_news/services/news_service.dart';
import 'package:catch_news/viewmodel/article_view_model.dart';
import 'package:catch_news/models/articles.dart';

enum Status { initial, loading, loaded }

class ArticleListViewModel extends ChangeNotifier {
  ArticleViewModel viewModel = ArticleViewModel('general', []);
  Status status = Status.initial;

  ArticleListViewModel() {
    getNews('general');
  }

  Future<List<Articles>> getNews(String category) async {
    status = Status.loading;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      viewModel.articles = await NewsService().fetchNews(category);
      status = Status.loaded;
      return viewModel.articles;
    } catch (e) {
      status = Status.initial;
      rethrow;
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }
}